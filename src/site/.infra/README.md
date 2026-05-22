# Site: GCP Infrastructure

## Deployments

Deployed manually in GitHub Actions via [deploy-site.yml](../../../.github/workflows/deploy-site.yml).

## Infrastructure Setup

Login to GCP and enable the following APIs:

- Artifact Registry API
- Cloud Run API
- IAM Credentials API

The workflow identity used by `SITE_GCP_WORKLOAD_IDENTITY_PROVIDER` must have the following attached roles:

- `roles/artifactregistry.admin`
- `roles/run.developer`
- `roles/iam.serviceAccountUser`

Setup the following GitHub Secrets:

- `GCP_PROJECT_ID`
- `GCP_REGION`
- `SITE_GCP_ARTIFACT_REPOSITORY`
- `SITE_GCP_WORKLOAD_IDENTITY_PROVIDER`
- `SITE_GCP_SERVICE_ACCOUNT`
- `CLOUD_RUN_SITE_SERVICE`

### Setup Script

Run [site-infra-setup.sh](site-infra-setup.sh) to create the required GCP APIs and infrastructure.

Environment variables are detailed in [.site.infra.sample.env](.site.infra.sample.env).
