# bcm.id.au


## Structure

- [.github/workflows](.github/workflows/) - GitHub Actions workflows.
- [.vscode](.vscode/) - Customised [VS Code](https://code.visualstudio.com/) project configuration.
- [.zed](.zed/) - Customised [Zed Editor](https://zed.dev/) project configuration.
- [bin](bin/) - Bash helper scripts, run `deno task` to show available options.
- [src](src/links/) - Source code for a self-hosted version of the [Karakeep](https://karakeep.app/) bookmarking service
- [src](src/site/) - Source code for the main public website at [murty.au](https://murty.au)
- [storage](storage/) - Used for persistent storage by local Docker containers

## Local Development

This project assumes that your local machine:

- Has [Docker Desktop](https://docs.docker.com/desktop/) installed and ready
- Is running a modern Linux OS

### Initial Setup

```bash
chmod +x ./bin/*.sh
bash ./bin/setup.sh
```
