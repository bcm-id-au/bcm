# Project: bcm

This repository provides automation scripts for configuring and provisioning a set of self-hosted systems.

## Tech Stack

- **OS Target:** Linux (Fedora Workstation, Ubuntu, etc)
- **Shell:** Bash (`/usr/bin/env bash`)
- **Containerization:** Docker (`docker`, `docker compose` and [Docker Desktop](https://docs.docker.com/desktop/)

## Shell Scripting Standards

To ensure scripts are safe, portable, and reliable across Fedora installations:

- **Shebang:** Always start scripts with `#!/usr/bin/env bash`.
- **Error Handling:** Use safe defaults and check execution status where appropriate.
- **Variable Quoting:** Always quote variable references (e.g., `"$DIR"`) to prevent word splitting and globbing issues.
- **Sudo Permissions:**
  - Avoid running entire scripts as root.
  - If a command requires `sudo`, ask the user to confirm and show the full suggested command

## Required Tools

If any of the below CLI commands aren't available, stop processing and explain the missing tool to the user.

- `bash`
- `git`
- `docker`
- `docker compose`

## Agent Guidelines & Safety Rules

- **Concise Responses:** Keep responses concise and based on factual information
- **Minimise Comments:** Minimise comments in code to only briefly explain the "why", contextual information and excess spacing is messy.
- **Strict Command Banishment:** Under no circumstances should the agent ever run `git commit`, or `git push` commands. Doing so is strictly forbidden by the project configuration.
- **No Destructive Operations:** Never delete system files or run modifying system commands without explaining their purpose and obtaining explicit permission from the user.
- **Syntax Validation:** Always run syntax validation `bash -n <script>` before proposing modifications to shell scripts.
- **Sandboxed Validation:** Validate all proposed changes locally within the sandbox before committing.

## Helpful Commands

- **Syntax check:** `bash -n setup.sh`
- **Execute installer:** `bash ./setup.sh`
