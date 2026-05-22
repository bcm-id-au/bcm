#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

cp -n "$script_dir/.site.infra.sample.env" "$script_dir/.site.infra.env"
source "$script_dir/.site.infra.env"

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

if [[ -z "${GCP_PROJECT_ID:-}" ]]; then
  echo "Missing required environment variable: GCP_PROJECT_ID" >&2
  exit 1
fi

if [[ -z "${GCP_REGION:-}" ]]; then
  echo "Missing required environment variable: GCP_REGION" >&2
  exit 1
fi

if [[ -z "${GCP_ARTIFACT_REPOSITORY:-}" ]]; then
  echo "Missing required environment variable: GCP_ARTIFACT_REPOSITORY" >&2
  exit 1
fi

if [[ -z "${CLOUD_RUN_SITE_SERVICE:-}" ]]; then
  echo "Missing required environment variable: CLOUD_RUN_SITE_SERVICE" >&2
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

project_id="$GCP_PROJECT_ID"
region="$GCP_REGION"
artifact_repository="$GCP_ARTIFACT_REPOSITORY"
cloud_run_site_service="$CLOUD_RUN_SITE_SERVICE"
github_repository="$GITHUB_REPOSITORY"
workload_pool="${GCP_WORKLOAD_POOL:-}"
workload_provider="${GCP_WORKLOAD_PROVIDER:-github}"
service_account_input="${GCP_SERVICE_ACCOUNT:-${cloud_run_site_service}-deployer}"

if [[ "$service_account_input" == *@* ]]; then
  service_account_email="$service_account_input"
  service_account_id="${service_account_input%@*}"
else
  service_account_id="$service_account_input"
  service_account_email="${service_account_id}@${project_id}.iam.gserviceaccount.com"
fi

echo "This script will configure the GCP project '$project_id'"
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
  iamcredentials.googleapis.com \
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
    --description "bcm site Cloud Run images"
fi

echo "Ensuring deployer service account exists..."
if ! gcloud iam service-accounts describe "$service_account_email" \
  --project "$project_id" \
  >/dev/null 2>&1; then
  gcloud iam service-accounts create "$service_account_id" \
    --project "$project_id" \
    --display-name "bcm site Cloud Run deployer"
fi

echo "Granting deployer project roles..."
for role in \
  roles/artifactregistry.admin \
  roles/run.developer \
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
    --display-name "bcm site GitHub"
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

workload_identity_provider="projects/${project_number}/locations/global/workloadIdentityPools/${workload_pool}/providers/${workload_provider}"

echo ''
echo 'Setup complete.'
echo ''
echo 'Add the following GitHub Secrets: '
echo "  - SITE_GCP_ARTIFACT_REPOSITORY=$artifact_repository"
echo "  - SITE_GCP_WORKLOAD_IDENTITY_PROVIDER=$workload_identity_provider"
echo "  - SITE_GCP_SERVICE_ACCOUNT=$service_account_email"
