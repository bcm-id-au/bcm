# Public Website

This directory contains the main [murty.au](https://murty.au/) public website.

## Tech Stack

- [Deno](https://deno.land/) - TypeScript, Deno Tests, Deno Tasks
- [Lume](https://lumeland.github.io/)
- [IO font by Mass-Driver](https://io.mass-driver.com/) - I have purchased a license for use here
- [Font Awesome icon pack](https://fontawesome.com/) - Using the Free icon pack here

## Structure

- [.github/workflows/deploy-site.yml](../../.github/workflows/deploy-site.yml) - Manual deployment workflow.
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

## Deployment

Releases can be manually triggered from GitHub Actions via the [Release and Deploy workflow](../../.github/workflows/release.yml).
