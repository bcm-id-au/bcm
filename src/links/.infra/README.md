# Links: GCP Infrastructure

## Deployments

Deployed manually in GitHub Actions via [deploy-links.yml](../../.github/workflows/deploy-links.yml)

## Infrastructure Setup

Login to GCP and enable the following APIs:

- Artifact Registry API
- Cloud Run API
- Cloud Storage API
- IAM Credentials API

The workflow identity (used by `LINKS_GCP_WORKLOAD_IDENTITY_PROVIDER`) must have the following attached roles:

- `roles/artifactregistry.admin`
- `roles/run.developer`
- `roles/storage.admin`
- `roles/iam.serviceAccountUser`

Setup the following GitHub Secrets:

- `GCP_PROJECT_ID`
- `GCP_REGION`
- `LINKS_GCP_ARTIFACT_REPOSITORY`
- `LINKS_GCP_WORKLOAD_IDENTITY_PROVIDER`
- `LINKS_GCP_SERVICE_ACCOUNT`
- `CLOUD_RUN_SERVICE`

### Setup Script

Run [links-infra-setup.sh](links-infra-setup.sh) to create the required GCP APIs and infrastructure.

Environment variables are detailed in [.links.infra.sample.env](.links.infra.sample.env)

### Storage

The top-level named volumes in `src/links/.infra/docker-compose.yml` are handled by [Cloud Run Compose](https://docs.cloud.google.com/run/docs/deploy-run-compose) as [Cloud Storage Volumes](https://docs.cloud.google.com/run/docs/configuring/services/cloud-storage-volume-mounts).
