#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

cp -n "$script_dir/.links.infra.sample.env" "$script_dir/.links.infra.env"
source "$script_dir/.links.infra.env"

if ! command -v bash >/dev/null 2>&1; then
  echo "Missing required tool: bash" >&2
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo "Missing required tool: git" >&2
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Missing required tool: docker" >&2
  exit 1
fi

if ! command -v gcloud >/dev/null 2>&1; then
  echo "Missing required tool: gcloud" >&2
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "Missing required tool: docker compose" >&2
  exit 1
fi

if [[ -z "${GCP_PROJECT_ID:-}" ]]; then
  echo "Missing required environment variable: GCP_PROJECT_ID" >&2
  exit 1
fi

if [[ -z "${GCP_ARTIFACT_REPOSITORY:-}" ]]; then
  echo "Missing required environment variable: GCP_ARTIFACT_REPOSITORY" >&2
  exit 1
fi

if [[ -z "${CLOUD_RUN_SERVICE:-}" ]]; then
  echo "Missing required environment variable: CLOUD_RUN_SERVICE" >&2
  exit 1
fi

if [[ -z "${GITHUB_REPOSITORY:-}" ]]; then
  echo "Missing required environment variable: GITHUB_REPOSITORY" >&2
  exit 1
fi

if [[ "$GITHUB_REPOSITORY" != */* ]]; then
  echo "GITHUB_REPOSITORY must use owner/repo format" >&2
  exit 1
fi

if [[ -n "${LINKS_DOMAIN:-}" && -z "${GCP_DNS_ZONE:-}" ]]; then
  echo "Missing required environment variable for LINKS_DOMAIN: GCP_DNS_ZONE" >&2
  exit 1
fi

if [[ -n "${LINKS_DOMAIN:-}" && -z "${GCP_DNS_NAME:-}" ]]; then
  echo "Missing required environment variable for LINKS_DOMAIN: GCP_DNS_NAME" >&2
  exit 1
fi

project_id="$GCP_PROJECT_ID"
region="asia-southeast1"
artifact_repository="$GCP_ARTIFACT_REPOSITORY"
cloud_run_service="$CLOUD_RUN_SERVICE"
github_repository="$GITHUB_REPOSITORY"
workload_pool="${GCP_WORKLOAD_POOL:-bcm-links-github}"
workload_provider="${GCP_WORKLOAD_PROVIDER:-github}"
service_account_input="${GCP_SERVICE_ACCOUNT:-${cloud_run_service}-deployer}"
links_domain="${LINKS_DOMAIN:-}"
dns_zone="${GCP_DNS_ZONE:-}"
dns_name="${GCP_DNS_NAME:-}"
domain_mapping_exists=false
NEXTAUTH_SECRET="${NEXTAUTH_SECRET:-replace-with-production-nextauth-secret}"
NEXTAUTH_URL="${NEXTAUTH_URL:-https://links.example-domain.com}"
MEILI_MASTER_KEY="${MEILI_MASTER_KEY:-replace-with-production-meili-master-key}"
OPENAI_API_KEY="${OPENAI_API_KEY:-replace-with-production-openai-api-key}"
INFERENCE_TEXT_MODEL="${INFERENCE_TEXT_MODEL:-gpt-4.1-mini}"
INFERENCE_IMAGE_MODEL="${INFERENCE_IMAGE_MODEL:-gpt-4o-mini}"
DISABLE_SIGNUPS="${DISABLE_SIGNUPS:-true}"
KARAKEEP_DISABLE_SIGNUPS="${KARAKEEP_DISABLE_SIGNUPS:-true}"
runtime_secret_names=(
  NEXTAUTH_SECRET
  NEXTAUTH_URL
  MEILI_MASTER_KEY
  OPENAI_API_KEY
  INFERENCE_TEXT_MODEL
  INFERENCE_IMAGE_MODEL
  DISABLE_SIGNUPS
  KARAKEEP_DISABLE_SIGNUPS
)

secret_id_for_env_name() {
  case "$1" in
    NEXTAUTH_SECRET)
      echo "${cloud_run_service}-nextauth-secret"
      ;;
    NEXTAUTH_URL)
      echo "${cloud_run_service}-nextauth-url"
      ;;
    MEILI_MASTER_KEY)
      echo "${cloud_run_service}-meili-master-key"
      ;;
    OPENAI_API_KEY)
      echo "${cloud_run_service}-openai-api-key"
      ;;
    INFERENCE_TEXT_MODEL)
      echo "${cloud_run_service}-inference-text-model"
      ;;
    INFERENCE_IMAGE_MODEL)
      echo "${cloud_run_service}-inference-image-model"
      ;;
    DISABLE_SIGNUPS)
      echo "${cloud_run_service}-disable-signups"
      ;;
    KARAKEEP_DISABLE_SIGNUPS)
      echo "${cloud_run_service}-karakeep-disable-signups"
      ;;
    *)
      echo "Unknown runtime secret environment variable: $1" >&2
      return 1
      ;;
  esac
}

if [[ -n "$dns_name" && "$dns_name" != *. ]]; then
  dns_name="${dns_name}."
fi

if [[ "$service_account_input" == *@* ]]; then
  service_account_email="$service_account_input"
  service_account_id="${service_account_input%@*}"
else
  service_account_id="$service_account_input"
  service_account_email="${service_account_id}@${project_id}.iam.gserviceaccount.com"
fi

echo "This script will configure the GCP project '$project_id'"

if [[ -n "$links_domain" ]]; then
  echo "It will also create/update Cloud DNS for '$dns_name' and map '$links_domain' to Cloud Run service '$cloud_run_service' in '$region'."
fi

echo ''

read -r -p "Continue creating/updating these GCP resources? [y/N] " answer
if [[ "$answer" != "y" && "$answer" != "Y" && "$answer" != "yes" && "$answer" != "YES" ]]; then
  echo "Cancelled."
  exit 0
fi

echo "Reading project number..."
project_number="$(gcloud projects describe "$project_id" --format='value(projectNumber)')"

echo "Enabling required APIs..."
gcloud services enable \
  artifactregistry.googleapis.com \
  run.googleapis.com \
  storage.googleapis.com \
  iamcredentials.googleapis.com \
  dns.googleapis.com \
  secretmanager.googleapis.com \
  --project "$project_id"

echo "Ensuring Artifact Registry repository exists..."
if ! gcloud artifacts repositories describe "$artifact_repository" \
  --project "$project_id" \
  --location "$region" \
  >/dev/null 2>&1; then
  gcloud artifacts repositories create "$artifact_repository" \
    --project "$project_id" \
    --location "$region" \
    --repository-format docker \
    --description "bcm links Cloud Run images"
fi

echo "Ensuring deployer service account exists..."
if ! gcloud iam service-accounts describe "$service_account_email" \
  --project "$project_id" \
  >/dev/null 2>&1; then
  gcloud iam service-accounts create "$service_account_id" \
    --project "$project_id" \
    --display-name "bcm links Cloud Run deployer"
fi

echo "Granting deployer project roles..."
for role in \
  roles/artifactregistry.admin \
  roles/run.developer \
  roles/storage.admin \
  roles/iam.serviceAccountUser; do
  gcloud projects add-iam-policy-binding "$project_id" \
    --member "serviceAccount:${service_account_email}" \
    --role "$role" \
    --condition=None \
    >/dev/null
done

echo "Ensuring Workload Identity pool exists..."
if ! gcloud iam workload-identity-pools describe "$workload_pool" \
  --project "$project_id" \
  --location global \
  >/dev/null 2>&1; then
  gcloud iam workload-identity-pools create "$workload_pool" \
    --project "$project_id" \
    --location global \
    --display-name "bcm links GitHub"
fi

echo "Ensuring GitHub OIDC provider exists..."
if ! gcloud iam workload-identity-pools providers describe "$workload_provider" \
  --project "$project_id" \
  --location global \
  --workload-identity-pool "$workload_pool" \
  >/dev/null 2>&1; then
  gcloud iam workload-identity-pools providers create-oidc "$workload_provider" \
    --project "$project_id" \
    --location global \
    --workload-identity-pool "$workload_pool" \
    --display-name "GitHub Actions" \
    --issuer-uri "https://token.actions.githubusercontent.com" \
    --attribute-mapping "google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository,attribute.repository_owner=assertion.repository_owner" \
    --attribute-condition "assertion.repository == '${github_repository}'"
fi

principal="principalSet://iam.googleapis.com/projects/${project_number}/locations/global/workloadIdentityPools/${workload_pool}/attribute.repository/${github_repository}"

echo "Granting GitHub repository permission to impersonate deployer..."
for role in \
  roles/iam.workloadIdentityUser \
  roles/iam.serviceAccountTokenCreator; do
  gcloud iam service-accounts add-iam-policy-binding "$service_account_email" \
    --project "$project_id" \
    --member "$principal" \
    --role "$role" \
    >/dev/null
done

if [[ -n "$links_domain" ]]; then
  echo "Ensuring Cloud DNS public zone exists..."
  if ! gcloud dns managed-zones describe "$dns_zone" \
    --project "$project_id" \
    >/dev/null 2>&1; then
    gcloud dns managed-zones create "$dns_zone" \
      --project "$project_id" \
      --dns-name "$dns_name" \
      --description "DNS zone for $dns_name"
  fi

  echo "Ensuring Cloud Run domain mapping exists..."
  if gcloud beta run domain-mappings describe \
    --project "$project_id" \
    --region "$region" \
    --domain "$links_domain" \
    >/dev/null 2>&1; then
    domain_mapping_exists=true
  elif gcloud run services describe "$cloud_run_service" \
    --project "$project_id" \
    --region "$region" \
    >/dev/null 2>&1; then
    gcloud beta run domain-mappings create \
      --project "$project_id" \
      --region "$region" \
      --service "$cloud_run_service" \
      --domain "$links_domain"
    domain_mapping_exists=true
  else
    echo "Skipping Cloud Run domain mapping because service '$cloud_run_service' does not exist in '$region' yet." >&2
    echo "Deploy the service with the links GitHub Actions workflow, then run this script again." >&2
  fi
fi

workload_identity_provider="projects/${project_number}/locations/global/workloadIdentityPools/${workload_pool}/providers/${workload_provider}"

echo ''
echo 'GCP setup completed.'
echo ''
echo '1. Add the following GitHub Secrets: '
echo "  - LINKS_GCP_ARTIFACT_REPOSITORY=$artifact_repository"
echo "  - LINKS_GCP_WORKLOAD_IDENTITY_PROVIDER=$workload_identity_provider"
echo "  - LINKS_GCP_SERVICE_ACCOUNT=$service_account_email"
echo ''
echo '2. Manually create or update the app env vars defined in ".links.sample.env" with suitable production values:'
echo "  https://console.cloud.google.com/security/secret-manager?project=${project_id}"

if [[ -n "$links_domain" ]]; then
  echo ''
  echo "Delegate '$dns_name' to these Cloud DNS name servers at your domain registrar:"
  gcloud dns record-sets list \
    --project "$project_id" \
    --zone "$dns_zone" \
    --name "$dns_name" \
    --type NS \
    --format "value(rrdatas[])"

  echo ''
  echo "Verify domain ownership if not already done:"
  echo "  gcloud domains verify ${dns_name%.}"

  echo ''
  if [[ "$domain_mapping_exists" == true ]]; then
    echo "Add these Cloud Run DNS records in Cloud DNS after delegation is active:"
    gcloud beta run domain-mappings describe \
      --project "$project_id" \
      --region "$region" \
      --domain "$links_domain" \
      --format "table(resourceRecords[].name,resourceRecords[].type,resourceRecords[].rrdata)"
  else
    echo "Cloud Run DNS records are not available yet because the domain mapping was not created."
    echo "Deploy '$cloud_run_service' to '$region', then run this script again."
  fi
fi
