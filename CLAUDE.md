# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

See [AGENTS.md](AGENTS.md) for the canonical agent instructions — the rules there (especially the Strict Command Banishment and shell scripting standards) apply to Claude Code as well. This file only adds Claude-specific context that isn't already in AGENTS.md.

## Hard rules (from AGENTS.md)

- **Never run** `git commit`, `git push`, `rm`, or `kill`. These are strictly forbidden by project configuration — even if a workflow seems to require them, stop and ask.
- Run `bash -n <script>` before proposing changes to shell scripts.
- If `sudo` is needed, do not invoke it — print the command and explain why instead.
- See `docs/AI-USE.md`: architectural/design decisions are human-driven; AI builds from a human design.

## Repository shape

Monorepo of self-hosted systems. The top-level `justfile` is the entry point for almost every workflow — prefer `just <command>` over invoking underlying scripts directly so behavior stays consistent with what the human runs.

- `src/links/` — Self-hosted [Karakeep](https://karakeep.app/) via `docker compose`. Deployed to GCP Cloud Run.
- `src/site/` — Public website at [murty.au](https://murty.au), built with Deno and [Lume](https://lumeland.github.io/) (static site).
- `src/schnitmydadsays/` and `src/upcomingtasks/` — Git submodules (see `.gitmodules`); these are separate repos, do not edit in-place without coordinating.
- `bin/` — Top-level helper scripts (setup, AI tooling install, release notes). Per-project scripts live under `src/<project>/bin/`.
- `storage/` — Persistent volumes for local Docker containers. Do not commit contents.
- `.github/workflows/` — Deploy workflows for site and links; site PR checks.

## Common commands

Everything runs through `just`. List commands with `just` (default) or `just list`.

- `just setup-local` — One-time local environment setup.
- `just git-branch <name>` — Branch from latest `develop` and push (used instead of manual `git checkout -b`).
- `just gh-pr` — Open a draft PR for the current branch targeting `develop`, using `.github/pull_request_template.md`.
- `just links-start` / `just links-stop` — Run the Karakeep stack locally.
- `just site-start` — Serve built site on port 8000 (requires a prior build).
- `just site-build` — Full build pipeline (lint, format, build, copy assets).
- `just site-test` — Run all Deno tests in `src/site/src`.
- `just site-new-post` — Scaffold a new blog post Markdown file.

### Site-specific (inside `src/site/`)

The project uses Deno tasks defined in `src/site/deno.json`:

- Single test: `deno test --allow-run=deno --allow-env --allow-read --allow-net src/site/src/<filename>.test.ts`
- `deno task lume <args>` — Invoke Lume directly (with the scoped permissions in `deno.json`).
- `deno task json-feed` — Regenerate `/brendan/posts.json` from `public/posts/`.

## Site build architecture (`src/site/`)

The build is **not** a plain `lume build` — it is orchestrated by `bin/site-build.sh`, which:

1. Lints/formats, then assembles a temporary `build/` directory by copying:
   - `src/styles/` → `build/_styles/`
   - `src/templates/` → `build/_includes/`
   - `src/layouts/` → `build/_includes/layouts/`
   - `content/*` → `build/`
2. Concatenates CSS files **in a fixed order** (`tools-reset.css`, `site.css`, `media-screen-medium.css`, `media-screen-small.css`, `media-print.css`) and minifies to `build/_assets/css/styles.min.css`. If you add a CSS file, update the concatenation order in `site-build.sh`.
3. Runs Lume to produce `public/`.
4. Copies static assets, runs `src/json-feed.ts`, then deletes `build/`.

Implications:

- `build/` is ephemeral; never edit files there or commit it.
- `public/` is generated output; do not hand-edit, do not commit.
- Tests in `src/site/src/*.test.ts` assert files exist and are non-empty in `public/`, so they require a prior `just site-build` to pass.

Environment variables come from `src/site/.env` (template: `.env.example`); `_config.ts` exposes them to Lume via `site.data()`.

## Links architecture (`src/links/`)

Docker Compose stack for Karakeep. `start-links.sh` / `stop-links.sh` are the only supported entry points locally. Deployment is a manual GitHub Actions trigger (`deploy_links.yml`) — see `src/links/README.md` for GCP setup, required secrets, and Workload Identity configuration.

## Submodules

`src/schnitmydadsays/` and `src/upcomingtasks/` are submodules. `just git-update` runs `git submodule update --remote --merge`. Treat their contents as foreign repos: changes there belong in their own PRs, not in `bcm`.
