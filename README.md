# Site

This repository contains a set of self-hosted systems.

## Structure

- [.github/workflows](.github/workflows/) - GitHub Actions workflows to deploy apps and infrastructure.
- [.vscode](.vscode/) - Customised [VS Code](https://code.visualstudio.com/) project configuration.
- [.zed](.zed/) - Customised [Zed Editor](https://zed.dev/) project configuration.
- [bin](bin/) - Bash helper scripts
- [docs](docs/) - Documentation and contextual information
- [design](design/) - Page layout and icon design files
- [src/links](src/links/) - A self-hosted version of the [Karakeep](https://karakeep.app/) bookmarking service.
- [src/schnitmydadsays](src/schnitmydadsays/) - Schnitzel review website.
- [src/site](src/site/) - My main public website at [murty.au](https://murty.au).
- [src/upcomingtasks](src/upcomingtasks/) - A web-based Basecamp 2 client.
- [storage](storage/) - Used for persistent storage by local Docker containers.

## Local Setup

The systems in this repository assume that your local machine:

- Is running a Linux OS like Fedora or Ubuntu
- Has an up-to-date version of [Docker CLI](https://docs.docker.com/desktop/) installed and ready
- Has an up-to-date version of [Deno](https://deno.com/) installed and ready
- Has an up-to-date version of [Just](https://github.com/casey/just) installed and ready
- Has an up-to-date version of [GitHub CLI](https://cli.github.com/) installed and ready

Note that my [dotfiles repository](https://github.com/brendanmurty/dotfiles) contains install scripts for most of the above items.

## Local Tools

Initial setup:

```bash
bash ./bin/setup.sh
```

This repository uses [Just](https://github.com/casey/just) to run commands defined in [justfile](justfile).

To list all of the available options for the `just` CLI, run:

```bash
just list
```
