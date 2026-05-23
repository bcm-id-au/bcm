# Links Service

This directory contains a self-hosted version of the [Karakeep](https://karakeep.app/) bookmarking service.

## Local Environment

- Start the local server: `just links-start`
- Stop the local server: `just links-stop`

## Online Infrastructure

### Deployments

Deployed to GCP manually in GitHub Actions via [deploy-links.yml](../../.github/workflows/deploy-links.yml)

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

Setup the following GitHub Secrets:

- `GCP_PROJECT_ID`
- `LINKS_GCP_ARTIFACT_REPOSITORY`
- `LINKS_GCP_WORKLOAD_IDENTITY_PROVIDER`
- `LINKS_GCP_SERVICE_ACCOUNT`
- `CLOUD_RUN_SERVICE`
- `LINKS_GCP_INFRA_CREDENTIALS_JSON` - the full JSON output of a GCP service account that has permission to create and update the infra resources

Links infrastructure is deployed to `asia-southeast1` due to limitations around region availability of some required GCP features.

### Storage

The top-level named volumes in `src/links/.infra/docker-compose.yml` are handled by [Cloud Run Compose](https://docs.cloud.google.com/run/docs/deploy-run-compose) as [Cloud Storage Volumes](https://docs.cloud.google.com/run/docs/configuring/services/cloud-storage-volume-mounts).

