# AI Agent Instructions

This repository contains a set of self-hosted systems.

## Tech Stack

- **OS Target:** Linux (Fedora Workstation, Ubuntu, etc)
- **Shell:** Bash (`/usr/bin/env bash`)
- **Containerization:** Docker (`docker`, `docker compose` and [Docker Desktop](https://docs.docker.com/desktop/)
- **Code:** Deno, TypeScript, Deno Tests

## Structure

- [.github/workflows](.github/workflows/) - GitHub Actions workflows.
- [.vscode](.vscode/) - Customised [VS Code](https://code.visualstudio.com/) project configuration.
- [.zed](.zed/) - Customised [Zed Editor](https://zed.dev/) project configuration.
- [bin](bin/) - Bash helper scripts.
- [src](src/links/) - Source code for a self-hosted version of the [Karakeep](https://karakeep.app/) bookmarking service.
- [src](src/site/) - Source code for the main public website at [murty.au](https://murty.au).
- [storage](storage/) - Used for persistent storage by local Docker containers.

## Shell Scripting Standards

To ensure scripts are safe, portable, and reliable across Fedora installations:

- **Shebang:** Always start scripts with `#!/usr/bin/env bash`.
- **Error Handling:** Use safe defaults and check execution status where appropriate.
- **Variable Quoting:** Always quote variable references (e.g., `"$DIR"`) to prevent word splitting and globbing issues.
- **Sudo Permissions:**
  - Avoid running entire scripts as root.
  - If a command requires `sudo`, stop processing and show the full suggested command along with an explanation as to why `sudo` is required

## Required Tools

If any of the below CLI commands aren't available, stop processing and explain the missing tool to the user.

- `bash`
- `git`
- `deno`
- `docker`
- `docker compose`

## Agent Guidelines & Safety Rules

- **Concise Responses:** Keep responses concise and based on factual information
- **Minimise Comments:** Minimise comments in code to only briefly explain the "why", contextual information and excess spacing is messy.
- **Strict Command Banishment:** Under no circumstances should the agent ever run `git commit`, `git push`, `rm` or `kill` commands. Doing so is strictly forbidden by the project configuration.
- **No Destructive Operations:** Never delete system files or run modifying system commands without explaining their purpose and obtaining explicit permission from the user.
- **Syntax Validation:** Always run syntax validation `bash -n <script>` before proposing modifications to shell scripts.
- **Sandboxed Validation:** Validate all proposed changes locally within the sandbox before committing.

## Helpful Commands

- **Syntax check:** `bash -n script-file-name.sh`

## Links: `src/links/`

The `src/links/` directory contains a self-hosted version of the [Karakeep](https://karakeep.app/) bookmarking service.

### Tech Stack

- **OS Target:** Linux (Fedora Workstation, Ubuntu, etc)
- **Shell:** Bash (`/usr/bin/env bash`)
- **Containerization:** Docker (`docker`, `docker compose` and [Docker Desktop](https://docs.docker.com/desktop/)

## Site: `src/site/`

The `src/site/` directory contains a static website built with Deno and Lume (static site generator).

### Build, Test, and Lint Commands

All commands are run via `deno task <command>`:

- **Build**: `deno task build` - Runs the full build pipeline (lint, format, build site, copy assets)
- **Test**: `deno task test` - Run all tests in the `src/` directory
  - Single test: `deno test --allow-run=deno --allow-env --allow-read --allow-net src/<filename>.test.ts`
- **Lint**: `deno task lint` - Run Deno lint and format
- **Local server**: `deno task serve` - Serve built site from `public/` directory on port 8000

Other useful commands:

- `deno task setup` - Initial setup (creates directories, installs dependencies)
- `deno task new-post` - Generate a new blog post Markdown file

### Architecture

#### Build Process

The build is orchestrated by `bin/build.sh` which:

1. Lints and formats code
2. Creates a temporary `build/` directory
3. Copies source files into the build directory structure:
   - `src/styles/` → `build/_styles/`
   - `src/templates/` → `build/_includes/`
   - `src/layouts/` → `build/_includes/layouts/`
   - `content/*` → `build/` (Markdown files with frontmatter)
4. Combines and minifies CSS files into `build/_assets/css/styles.min.css`
5. Runs Lume to generate static HTML from Markdown + Nunjucks templates
6. Copies static assets (fonts, images, config files) to `public/`
7. Generates JSON Feed for blog posts via `src/json-feed.ts`
8. Cleans up `build/` directory

#### Directory Structure

- **`assets/`**: Static files (fonts, images, PDFs, favicon, etc.)
- **`bin/`**: Bash scripts for common tasks
- **`content/`**: Markdown files for pages and posts with frontmatter (e.g., `layout: home.njk`)
- **`src/`**: TypeScript source code
  - `src/layouts/`: Nunjucks layout templates (`.njk`)
  - `src/templates/`: Nunjucks component templates
  - `src/styles/`: CSS files (combined and minified during build)
  - `*.ts`: Utility modules (json-feed, posts-list)
  - `*.test.ts`: Deno tests (use `Deno.test()` with steps)
- **`public/`**: Built output (generated, not committed)
- **`build/`**: Temporary directory during build (cleaned up after)

#### Configuration

Environment variables are loaded from `.env` (use `.env.example` as template):

- `BLOG_POSTS_DIR`, `BLOG_POSTS_URL`: Blog post paths
- `JSON_FEED_*`: JSON Feed metadata (title, description, author, etc.)

These values are passed to Lume templates via `site.data()` in `_config.ts`.

#### Lume Plugins

The site uses these Lume plugins:

- `nunjucks` - Template engine
- `date` - Date formatting
- `redirects` - URL redirects
- `sitemap` - Generate sitemap.xml

#### JSON Feed Generation

Blog posts are published as a JSON Feed at `/brendan/posts.json`:

- Run via `deno task json-feed`
- Reads Markdown files from `public/posts/`
- Parses frontmatter and content
- Outputs JSON Feed 1.1 format
- See `src/types.ts` for type definitions

### Key Conventions

#### Testing

- Tests use Deno's built-in test framework with `Deno.test()`
- Tests use `test.step()` for sub-tests
- Tests are co-located with source files (e.g., `json-feed.ts` and `json-feed.test.ts`)
- Tests check for file existence and non-empty content in `public/` directory
- Run tests: `deno task test`

#### CSS Organization

CSS is split across multiple files that are concatenated in a specific order:

1. `tools-reset.css` - CSS reset
2. `site.css` - Base styles
3. `media-screen-medium.css` - Medium screen responsive styles
4. `media-screen-small.css` - Small screen responsive styles
5. `media-print.css` - Print styles

The build process concatenates and minifies these into `styles.min.css`.

#### Frontmatter in Content Files

Markdown files in `content/` use YAML frontmatter:

```yaml
---
layout: home.njk
tags: [Social, Work]
draft: false
---
```

See `src/types.ts` for the `YamlData` type definition.

### Code Style

- Formatting configured in `deno.json`:
  - 2 space indentation
  - Line width: 120
  - Semicolons required
  - No tabs
- Linting and formatting scoped to `src/`, `_config.ts`, and `deno.json`
