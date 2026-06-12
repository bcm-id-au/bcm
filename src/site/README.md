# Site

This directory contains the main [murty.au](https://murty.au/) public website.

## Tech Stack

- [Deno](https://deno.land/) - TypeScript, Deno Tests, Deno Tasks.
- [Lume](https://lume.land/) - Static site generator for Deno.
- [IO font by Mass-Driver](https://io.mass-driver.com/) - I have purchased a license for use here.
- [Font Awesome icon pack](https://fontawesome.com/) - Using the Free icon pack here.

## Structure

- [.github/workflows/site-release.yml](../../.github/workflows/site-release.yml) - Deployment workflow that can be manually triggered.
- [.github/workflows/site-check.yml](../../.github/workflows/site-check.yml) - Test workflow that runs automatically on PRs and can be manually triggered.
- [assets](assets/) - Static files like images and PDFs.
- [content](content/) - Website page content in [Markdown](https://daringfireball.net/projects/markdown/syntax) files.
- [src/backend](src/backend/) - Backend server, config setup and related unit tests.
- [src/frontend](src/frontend/) - Frontend styles, layouts and templates.
- [src/frontend/lume.config.ts](src/frontend/lume.config.ts) - Configuration and setup for [Lume](https://lume.land/).
- [AGENTS.md](AGENTS.md) - AI Agent instructions, technical docs and guidance.
- [deno.jsonc](deno.jsonc) - [Deno](https://deno.land/) imports, tasks and configuration.

## Initial Setup

1. Fork this repository
2. Make a local clone of that forked repository, apply the below updates
3. Install the [latest stable release of Deno](https://deno.com/)
4. Run the setup script: `deno task setup`
5. Update GitHub repository references in the files to use your forked GitHub repository URL instead
6. All files in the `content` directory **must** contain your own content instead
7. All files in the `assets` directory **must** contain your own static files instead
8. Purchase your own license to use the [Mass-Driver IO font](https://io.mass-driver.com/) or update the CSS to use other fonts
9. Commit and push all of these changes to your forked repository
10. Setup online infrastructure by following the steps in the `Infrastructure` section below
11. Setup your local development environmenmt by copying [.site.local.env](.site.local.env) to `.site.env` and then update `.site.env` to match your site

## Usage

- `deno task setup`: Local environment setup.
- `deno task build`: Build the site and organise the required assets.
- `deno task start`: Start a local web server.
- `deno task test`: Run all Deno Test scripts in the 'src' directory.
- `deno task install`: Install third-party dependencies.
- `deno task update`: Update third-party dependencies.
- `deno task clean`: Run code cleanup tools.
- `deno task lume`: Run a Lume command.
- `deno task new-post`: Generate a Markdown file for a new post item.
- `deno task docker-build`: Run the Docker Image build process.
- `deno task docker-start`: Start the Docker Container.
- `deno task docker-stop`: Stop the Docker Container.

## Deployment

Releases can be manually triggered from GitHub Actions via [site-release.yml](../../.github/workflows/site-release.yml).

## Infrastructure

First add new GitHub Environments (`GitHub Repo > Settings > Code and automation > Environments`):

- `ci-build`
- `gcp-cloud-run`

Now follow the steps in the comments in the sample file at [.site.github.env](.site.github.env).

### Deploy to [GCP Cloud Run](https://cloud.google.com/run)

Each GitHub Secret must be added to `GitHub Repo > Settings > Code and automation > Environments > gcp-cloud-run > Add environment secret`

These Google Cloud APIs need to be enabled:

- `Artifact Registry`
- `Cloud Run`
- `IAM Credentials`
- `Cloud Storage`

Setup a new Workload Identity Provider with these Roles:

- `Artifact Registry Admin`
- `Cloud Run Developer`

Setup a new Cloud Run service:

- Enable the `Cloud Run API` if prompted
- Set the name to something descriptive, eg: `jane-site-production`
  - Use this same name for the value of `SITE_GCP_CLOUD_RUN_SERVICE_NAME`
- Click the `Variables & Secrets` tab
  - Copy the full contents of your `.site.env` to the first `Name` field
  - Update the values to match production use
  - Don't forget to change `SITE_ENV` to something else like `prod`, `staging`, etc

Setup a new [GitHub Token](https://github.com/settings/tokens/new):

- Note: `GitHub Actions Deploy - GCP access to GitHub Packages`
- Expiration: `(set a short expiration and a reminder for yourself to renew it)`
- Scopes:
  - `write:packages`
  - `repo`
- Click `Generate token`
- Click the `copy` button and `save that to a file` for use in **Step 5** below

Setup a Remote Artifact Registry repository:

- Refer to the official [Google Cloud documentation](https://docs.cloud.google.com/artifact-registry/docs/repositories/remote-repo#create)
- Name: `github-packages`
- Format: `Docker`
- Mode: `Remote`
- Remote repository source: `Custom` > `https://ghcr.io`
- Remote repository authentication mode:
  - Authenticated
  - Username: `(your GitHub username)`
  - Secret: `(click Create new Secret, name it GITHUB_TOKEN_PACKAGES, and use the value of the token from Step 4 above)`
  - Use latest version: `(enabled)`
- Region: `set to the same as what you set in SITE_GCP_REGION`
- Other options: `(leave with their default values)`
- Click: Create
- Click: Copy path
- Save the value to the `SITE_GCP_DOCKER_IMAGE_URL` secret

Setup a new Service Account:

- Name: `site-deployer`
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
- Save the full content of the file to the `SITE_GCP_SERVICE_ACCOUNT_JSON` secret

### Point domain to GCP Cloud Run service

To set this live on your domain (`SITE_URL` from your `.site.env` file) you need to complete the following extra initial manual setup:

1. [GCP Cloud DNS - Create a public zone](https://docs.cloud.google.com/dns/docs/zones#create-pub-zone)
2. [GCP Cloud Run - Mapping custom domains](https://docs.cloud.google.com/run/docs/mapping-custom-domains)
