# bcm

This repository contains a set of self-hosted systems and websites.

## Structure

- [.github/workflows](.github/workflows/) - GitHub Actions workflows to deploy apps and infrastructure.
- [.vscode](.vscode/) - Customised [VS Code](https://code.visualstudio.com/) project configuration.
- [.zed](.zed/) - Customised [Zed Editor](https://zed.dev/) project configuration.
- [bin](bin/) - Supporting tools and scripts.
- [docs](docs/) - Documentation and contextual information.
- [design](design/) - Page layout and icon design files.
- [src/links](src/links/) - A self-hosted version of the [Karakeep](https://karakeep.app/) bookmarking service.
- [src/schnitmydadsays](https://github.com/brendanmurty/schnitmydadsays) - Schnitzel review website.
- [src/site](src/site/) - My main public website at [murty.au](https://murty.au).
- [src/upcomingtasks](https://github.com/brendanmurty/upcomingtasks) - A web-based Basecamp 2 client.
- [storage](storage/) - Used for persistent storage by local Docker containers.
- [.editorconfig](.editorconfig) - Sets basic code style rules via [EditorConfig](https://editorconfig.org)
- [justfile](justfile) - Project specific commands for [Just](https://github.com/casey/just)

## Local Setup

The systems in this repository assume that your local machine:

- Is running a Debian-based Linux OS
- Has an up-to-date version of [Docker CLI](https://docs.docker.com/desktop/) installed and ready
- Has an up-to-date version of [Deno](https://deno.com/) installed and ready
- Has an up-to-date version of [Just](https://github.com/casey/just) installed and ready
- Has an up-to-date version of [Homebrew](https://brew.sh/) installed and ready
- Has an up-to-date version of [GitHub CLI](https://cli.github.com/) installed and ready

Note that my [dotfiles repository](https://github.com/brendanmurty/dotfiles) contains install scripts for most of the above items.

## Local Tools

Run [bin/setup-local.sh](bin/setup-local.sh) to setup your local environment.

```bash
bash ./bin/setup-local.sh
```

This repository uses [Just](https://github.com/casey/just) to run commands defined in [justfile](justfile).

These commands can be run in a Terminal session from any sub-directory of the repository.

To list all of the available options, run:

```bash
just list
```
