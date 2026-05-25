# Links Service

This directory contains a self-hosted version of the [Karakeep](https://karakeep.app/) bookmarking service.

## Local Environment

Start the local server:

```bash
just links-start
```

Stop the local server:

```bash
just links-stop
```

## Online Infrastructure

### Deployment

App builds can be deployed to GCP manually in GitHub Actions via [deploy_links.yml](../../.github/workflows/deploy_links.yml)

### Infrastructure Setup

Manual setup steps for GCP detailed below.

Use the `asia-southeast1` region as some required GCP features aren't supported in the Sydney region.

1. Login to GCP and select the target project.
2. Enable the required APIs:
   - Artifact Registry API
   - Cloud Run API
   - Cloud Storage API
   - IAM Credentials API
   - Cloud DNS API
   - Secret Manager API
3. Create an Artifact Registry Docker repository for Links in `asia-southeast1`.
4. Create the Links deployer service account. By default this is `<cloud-run-service>-deployer`, unless a service account name or email is supplied.
5. Grant the deployer service account these project roles:
   - `roles/artifactregistry.admin`
   - `roles/run.developer`
   - `roles/storage.admin`
   - `roles/iam.serviceAccountUser`
6. Create a Workload Identity pool for GitHub Actions. The workflow default is `bcm-links-github`.
7. Create a GitHub OIDC provider in that pool. The workflow default provider name is `github`.
   - Issuer: `https://token.actions.githubusercontent.com`
   - Attribute mapping: `google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository,attribute.repository_owner=assertion.repository_owner`
   - Attribute condition: `assertion.repository == '<github-owner>/<github-repo>'`
8. Grant the GitHub repository principal access to impersonate the deployer service account:
   - `roles/iam.workloadIdentityUser`
   - `roles/iam.serviceAccountTokenCreator`
9. If `LINKS_DOMAIN` is configured, create a public Cloud DNS managed zone for `LINKS_GCP_DNS_NAME`.
10. Deploy the Cloud Run service with the app deployment workflow.
11. If `LINKS_DOMAIN` is configured, create the Cloud Run domain mapping for the deployed service.
12. Delegate the DNS name to the Cloud DNS name servers at the domain registrar, verify domain ownership if required, then add the Cloud Run DNS records shown by the domain mapping.

The resulting values required by the app deployment workflow are:

- `LINKS_GCP_ARTIFACT_REPOSITORY`
- `LINKS_GCP_WORKLOAD_IDENTITY_PROVIDER`
- `LINKS_GCP_SERVICE_ACCOUNT`

Manual production app secrets should be created in Secret Manager from the values defined in `.links.sample.env`.

#### GitHub Secrets

Add the below items to the list at `GitHub Repo > Settings > Secrets and variables > Actions > Repository secrets`.

- `LINKS_GCP_PROJECT_ID` - Required, eg: `example-project-111222`
- `LINKS_GCP_ARTIFACT_REPOSITORY`
- `LINKS_GCP_WORKLOAD_IDENTITY_PROVIDER` - eg: `projects/1234/locations/global/workloadIdentityPools/links-example-domain`
- `LINKS_GCP_WORKLOAD_POOL` - Optional, defaults to `bcm-links-github`
- `LINKS_GCP_WORKLOAD_PROVIDER_NAME` - Optional, defaults to `github`
- `LINKS_GCP_CLOUD_RUN_SERVICE_PREFIX`
- `LINKS_GCP_APP_CREDENTIALS_EMAIL` - email for a GCP Service Account with roles below
- `LINKS_GCP_APP_CREDENTIALS_JSON` - JSON key for a GCP Service Account with roles below
- `LINKS_GCP_INFRA_CREDENTIALS_JSON` - JSON key for a GCP Service Account with roles below
- `LINKS_DOMAIN` - Optional, eg: `links.example-domain.com`
- `LINKS_GCP_DNS_ZONE` - Required if `LINKS_DOMAIN` is set, eg: `example-domain-com`
- `LINKS_GCP_DNS_NAME` - Required if `LINKS_DOMAIN` is set, eg: `example-domain.com.`

Required GCP Roles for the **Apps Service Account**:

- `roles/artifactregistry.admin`
- `roles/run.developer`
- `roles/iam.serviceAccountUser`
- `roles/storage.admin`

Required GCP Roles for the **Infra Service Account**:

- `roles/artifactregistry.admin`
- `roles/run.developer`
- `roles/storage.admin`
- `roles/iam.serviceAccountUser`
- `roles/iam.workloadIdentityUser`
- `roles/iam.serviceAccountTokenCreator`

### Storage

The top-level named volumes in `src/links/.infra/docker-compose.yml` are handled by [Cloud Run Compose](https://docs.cloud.google.com/run/docs/deploy-run-compose) as [Cloud Storage Volumes](https://docs.cloud.google.com/run/docs/configuring/services/cloud-storage-volume-mounts).
