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

### Deployments

Deployed to GCP manually in GitHub Actions via [deploy-links-app.yml](../../.github/workflows/deploy-links-app.yml)

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

- `GCP_PROJECT_ID`
- `LINKS_GCP_ARTIFACT_REPOSITORY`
- `LINKS_GCP_WORKLOAD_IDENTITY_PROVIDER`
- `LINKS_GCP_SERVICE_ACCOUNT`
- `LINKS_GCP_CLOUD_RUN_SERVICE_PREFIX`
- `LINKS_GCP_INFRA_CREDENTIALS_JSON` - the full JSON output of a GCP service account with infra create and update permissions

Optional:

- `LINKS_DOMAIN` - eg `links.example-domain.com`
- `GCP_DNS_ZONE` - eg `example-domain-com`
- `GCP_DNS_NAME` - eg `example-domain.com.`

### Storage

The top-level named volumes in `src/links/.infra/docker-compose.yml` are handled by [Cloud Run Compose](https://docs.cloud.google.com/run/docs/deploy-run-compose) as [Cloud Storage Volumes](https://docs.cloud.google.com/run/docs/configuring/services/cloud-storage-volume-mounts).
