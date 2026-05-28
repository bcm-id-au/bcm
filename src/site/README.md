# Site

This directory contains the main [murty.au](https://murty.au/) public website.

## Tech Stack

- [Deno](https://deno.land/) - TypeScript, Deno Tests, Deno Tasks
- [Lume](https://lumeland.github.io/)
- [IO font by Mass-Driver](https://io.mass-driver.com/) - I have purchased a license for use here
- [Font Awesome icon pack](https://fontawesome.com/) - Using the Free icon pack here

## Structure

- [.github/workflows/site-deploy.yml](../../.github/workflows/site-deploy.yml) - Manual deployment workflow.
- [assets](assets/) - Static files like images and PDFs.
- [config](config/) - Supporting configuration files.
- [content](content/) - Website page content in [Markdown](https://daringfireball.net/projects/markdown/syntax) files.
- [src](src/) - Source code and related unit tests.
- [src/layouts](src/layouts/) - Nunjucks page layouts.
- [src/styles](src/styles/) - CSS styles.
- [src/templates](src/templates/) - Nunjucks page templates.
- [AGENTS.md](AGENTS.md) - AI Agent instructions, technical docs and guidance.
- [deno.json](deno.json) - [Deno](https://deno.land/) imports, tasks and configuration.

## Initial Setup

1. Fork this repository
2. Make a local clone of that forked repository
3. Install the [latest stable release of Deno](https://deno.com/)
4. Run the setup script: `deno task setup`
5. Update some files in the forked repository:

- Update `.github/workflows/release.yml` to use your forked GitHub repository URL
- All files in the `content` directory **must** contain your own content instead
- All files in the `assets` directory **must** contain your own static files instead
- Purchase your own license to use the [Mass-Driver IO font](https://io.mass-driver.com/) or update the CSS to use other fonts

6. Commit and push all of these changes to your forked repository
7. Update the Settings for your forked repository via GitHub:

- Pages > Source: _GitHub Actions_
- Pages > Custom domain: _example-your-domain.com_
- Actions > General > Workflow permissions: _Read and write permissions_

8. Update `CNAME` to use the same domain as you configured above
9. For GitHub Actions, setup new Environments and Secrets as noted in [.site.github.env](.site.github.env)
10. For local development, copy [.site.local.env](.site.local.env) to `.site.env` and update the Git Ignored file `.site.env` to match your site

## Deployment

Releases can be manually triggered from GitHub Actions via [site-deploy.yml](../../.github/workflows/site-deploy.yml).

## Infrastructure

Follow the instructions in [.site.github.env](.site.github.env).

**Optionally**, you can configure deployment to [GCP Cloud Run](https://cloud.google.com/run) by following the manual steps below.

Each GitHub Secret must be added to `GitHub Repo > Settings > Code and automation > Environments > gcp-cloud-run > Add environment secret`

1. Enable these Google Cloud APIs:
  - `Artifact Registry`
  - `Cloud Run`
  - `IAM Credentials`
2. Setup a new Workload Identity Provider with these Roles:
  - `Artifact Registry Admin`
  - `Cloud Run Developer`
3. Setup a Cloud Run service:
  - Enable the `Cloud Run API` if prompted
  - Set the name to something descriptive, eg: `jane-site-production`
  - Use this same name for the value of `SITE_GCP_CLOUD_RUN_SERVICE_NAME`
4. Setup a new [GitHub Token](https://github.com/settings/tokens/new):
  - Note: `GitHub Actions Deploy - GCP access to GitHub Packages`
  - Expiration: `(set a short expiration and a reminder for yourself to renew it)`
  - Scopes:
    - `write:packages`
    - `repo`
  - Click `Generate token`
  - Click the `copy` button and `save that to a file` for use in **Step 5** below
5. Setup a Remote Artifact Registry repository:
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
6. Setup a new Service Account:
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
