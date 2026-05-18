# Murty Website

## Summary

This repository contains the [murty.au](https://murty.au/) website, which has been built with [Deno](https://deno.land/), [Lume](https://lumeland.github.io/), a licensed version of the [IO font by Mass-Driver](https://io.mass-driver.com/), and the free [Font Awesome icon pack](https://fontawesome.com/).

Tests, build and local server commands are available from local environments.

Releases can be manually triggered via the `Release` [GitHub Action Workflow](.github/workflows/release.yml), which includes checking the test and build processed work before starting a new deployment [Deno Deploy](https://deno.com/deploy). It then publishes a new [GitHub Release](https://github.com/bcm-id-au/site/releases).

## Structure

- [.github/workflows/release.yml](.github/workflows/release.yml) - Release and deployment workflow.
- [.vscode](.vscode/) - Customised [VS Code](https://code.visualstudio.com/) project configuration.
- [.zed](.zed/) - Customised [Zed Editor](https://zed.dev/) project configuration.
- [assets](assets/) - Static files like images and PDFs.
- [bin](bin/) - Bash helper scripts, run `deno task` to show available options.
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
5. Update some files in the forked repository

- Update `.github/workflows/release.yml` to use your forked GitHub repository URL
- All files in the `content` directory **must** contain your own content instead
- All files in the `assets` directory **must** contain your own static files instead
- Purchase your own license to use the [Mass-Driver IO font](https://io.mass-driver.com/) or update the CSS to use other fonts

6. Commit and push all of these changes to your forked repository
7. Setup your own [Deno Deploy](https://deno.com/deploy) Org, Project and Personal Access Token
8. Update the Settings for your forked repository via GitHub:

- Go to `Settings > Security > Secrets and variables > Actions`
- Add new `Repository secrets` for the variables in [.env.github.example](.env.github.example)
- Update the `deploy` section in [deno.json](deno.json) to use your own Deno Deploy org and app

9. Setup [Fathom Analytics](https://usefathom.com/):

- Create a new site in your own account
- Update your `.env` file's `FATHOM_SITE_CODE` value to use your new `Fathom Site ID`
