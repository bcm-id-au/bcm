# Site

This repository contains a set of self-hosted systems.

## Structure

- [.github/workflows](.github/workflows/) - GitHub Actions workflows.
- [.vscode](.vscode/) - Customised [VS Code](https://code.visualstudio.com/) project configuration.
- [.zed](.zed/) - Customised [Zed Editor](https://zed.dev/) project configuration.
- [bin](bin/) - Bash helper scripts
- [src/links](src/links/) - Source code for a self-hosted version of the [Karakeep](https://karakeep.app/) bookmarking service.
- [src/links/.infra](src/links/.infra/) - GCP infrastructure setup for the Links system.
- [src/site](src/site/) - Source code for the main public website at [murty.au](https://murty.au).
- [storage](storage/) - Used for persistent storage by local Docker containers.

## Requirements

The systems in this respository assume that your local machine:

- Is running a Linux OS like Fedora or Ubuntu
- Has an up-to-date version of [Docker Desktop](https://docs.docker.com/desktop/) installed and ready
- Has an up-to-date version of [Deno](https://deno.com/) installed and ready
- Has an up-to-date version of [Just](https://github.com/casey/just) installed and ready

## Tools

This repository uses [Just](https://github.com/casey/just) to run commands from [justfile](justfile).

To see the available options for the `just` CLI, run:

```bash
just list
```
