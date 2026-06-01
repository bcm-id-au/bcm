# Copilot instructions for this repository

## Purpose

- Provide quick, repo-specific guidance for future Copilot/agent sessions. Pulls together build/test/lint commands, high-level architecture, and repository-specific conventions (AI agent rules live in AGENTS.md / CLAUDE.md).

## Build, test, and lint

- Preferred orchestration: just (top-level). List commands from any subdir:
  - just list
- Site (src/site) via Deno tasks (deno.json):
  - Full build (lint, format, build, copy assets): deno task build
  - Run all site tests: deno task test
  - Lint & format: deno task lint
  - Single test file example: deno test --allow-run=deno --allow-env --allow-read --allow-net src/site/src/<filename>.test.ts
  - Serve built site: deno task serve
  - Run Lume directly: deno task lume -- <args>
- Note: several just targets wrap these (e.g. just site-build, just site-test). Prefer running just when available.

## High-level architecture

- Monorepo of self-hosted systems managed from the repo root with a justfile.
- Key projects under src/:
  - src/site — Deno + Lume static site (murty.au). Build is orchestrated by bin/site-build.sh and deno tasks. Output: public/ (generated) and build/ (ephemeral).
  - src/links — Karakeep bookmark service (Docker Compose), deployed separately.
  - src/schnitmydadsays and src/upcomingtasks — git submodules (treated as separate repos).
- bin/ — helper scripts (site build, setup, release-notes). Use the provided scripts (avoid reimplementing flow).
- .github/workflows — deployment and PR checks (site-release.yml, site-check.yml).
- storage/ — persistent volumes for local Docker; do NOT commit contents.

## Key conventions and behaviours

- Agent safety & workflow: Follow AGENTS.md and CLAUDE.md. Important rules: do NOT run git commit/git push/rm/kill; run `bash -n <script>` before proposing script edits; prefer concise output.
- Use just from repo root for higher-level tasks rather than calling scripts directly.
- Site build specifics:
  - bin/site-build.sh assembles a temporary build/ and concatenates CSS in a fixed order — update the script if you add CSS files.
  - public/ is generated; do not edit or commit.
  - Tests often assert files in public/ exist — run site-build before site-test in CI or locally.
- Scripts: Must start with #!/usr/bin/env bash, quote variables, avoid running entire scripts as root. If sudo is required, do not run it automatically; instead show the command and explain why.
- Submodules: Treat src/schnitmydadsays and src/upcomingtasks as external; changes there belong in their own PRs against their repos.
- Formatting & linting: follow deno.json formatter and lint settings (2-space indent, 120 col, semicolons). Deno tasks `deno task lint` and `deno fmt` are the canonical tools.

## AI / Assistant integration notes

- AGENTS.md and CLAUDE.md are authoritative for agent behaviour. They list required CLI tools (bash, git, deno, docker, docker compose) and safety rules.
- If a Copilot session needs to modify shell scripts, run `bash -n <script>` first and include the result.
