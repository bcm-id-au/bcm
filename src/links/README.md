# Links

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

App builds can be deployed to GCP manually in GitHub Actions via [links-deploy.yml](../../.github/workflows/links-deploy.yml)

### Infrastructure Setup

## Infrastructure

First add new GitHub Environments (`GitHub Repo > Settings > Code and automation > Environments`):

- `ci-build`
- `gcp-cloud-run`
- `github-packages`

Now follow the steps in the comments in the sample file at [.links.github.env](.links.github.env).

### Deploy to [GCP Cloud Run](https://cloud.google.com/run)

Each GitHub Secret must be added to `GitHub Repo > Settings > Code and automation > Environments > gcp-cloud-run > Add environment secret`

1. Enable these Google Cloud APIs:
  - `Artifact Registry`
  - `Cloud Run`
  - `IAM Credentials`
  - `Cloud Storage`
2. Setup a new Workload Identity Provider with these Roles:
  - `Artifact Registry Admin`
  - `Cloud Run Developer`
3. Setup a Cloud Run service:
  - Enable the `Cloud Run API` if prompted
  - Set the name to something descriptive, eg: `jane-links-production`
    - Use this same name for the value of `LINKS_GCP_CLOUD_RUN_SERVICE_NAME`
  - Click the `Variables & Secrets` tab
    - Copy the full contents of your `.links.env` to the first `Name` field
    - Update the values to match production use
6. Setup a new Service Account:
  - Name: `links-deployer`
  - Assign Roles:
      - Artifact Registry Admin
      - Cloud Run Developer
      - Service Account User
      - Secret Manager Admin
      - Access Context Manager Editor
  - Description: `Used by GitHub Actions to deploy to Cloud Run`
  - Click: `Save`
  - Go to the `Keys` tab and click: `Add key > Create new key > JSON > Create`
    - `WARNING`: Treat this JSON file as a password!
      After you've saved it to GitHub Secrets, permanently delete the file.
  - Save the full content of the file to the `LINKS_GCP_SERVICE_ACCOUNT_JSON` secret

### Point domain to GCP Cloud Run service

To set this live on your domain (`LINKS_URL` from your `.links.env` file) you need to complete the following extra initial manual setup:

1. [GCP Cloud DNS - Create a public zone](https://docs.cloud.google.com/dns/docs/zones#create-pub-zone)
2. [GCP Cloud Run - Mapping custom domains](https://docs.cloud.google.com/run/docs/mapping-custom-domains)

### Storage

The storage volumes defined in [docker-compose.prod.yml](docker-compose.prod.yml) are automatically handled by [Cloud Run Compose](https://docs.cloud.google.com/run/docs/deploy-run-compose) as [Cloud Storage Volumes](https://docs.cloud.google.com/run/docs/configuring/services/cloud-storage-volume-mounts).
