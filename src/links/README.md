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

App builds can be deployed to GCP manually in GitHub Actions via [deploy_links_app.yml](../../.github/workflows/deploy_links_app.yml)

Infrastructure configuration can be deployed to GCP manually in GitHub Actions via [deploy_links_infra.yml](../../.github/workflows/deploy_links_infra.yml)

Links infrastructure is deployed to `asia-southeast1` due to limitations around region availability of some required GCP features.

### Infrastructure Setup

Login to GCP and enable the following APIs:

- Artifact Registry API
- Cloud Run API
- Cloud Storage API
- IAM Credentials API
- Cloud DNS API

The workflow identity (used by `LINKS_GCP_WORKLOAD_IDENTITY_PROVIDER`) must have the following attached roles:

- `roles/artifactregistry.admin`
- `roles/run.developer`
- `roles/storage.admin`
- `roles/iam.serviceAccountUser`

#### GitHub Secrets

Add the below items to the list at `GitHub Repo > Settings > Secrets and variables > Actions > Repository secrets`.

- `GCP_PROJECT_ID` - Required, eg: `example-project-111222`
- `LINKS_GCP_ARTIFACT_REPOSITORY`
- `LINKS_GCP_WORKLOAD_IDENTITY_PROVIDER`
- `LINKS_GCP_CLOUD_RUN_SERVICE_PREFIX`
- `LINKS_GCP_APP_CREDENTIALS_EMAIL` - email for a GCP Service Account with roles below
- `LINKS_GCP_APP_CREDENTIALS_JSON` - JSON key for a GCP Service Account with roles below
- `LINKS_GCP_INFRA_CREDENTIALS_JSON` - JSON key for a GCP Service Account with roles below
- `LINKS_DOMAIN` - Optional, eg: `links.example-domain.com`
- `GCP_DNS_ZONE` - Optional, eg: `example-domain-com`
- `GCP_DNS_NAME` - Optional, eg: `example-domain.com.`

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
