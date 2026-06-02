#!/usr/bin/env just --justfile
#
#
# Just command runner configuration
#   - You can run the commands from any directory, eg: just list
#   - More info at https://github.com/casey/just
#
#

# Set default config

set shell := ["bash", "-uc"]
set ignore-comments := true
set quiet := true

# Add alias commands

alias help := list
alias ls := list
alias menu := choose
alias select := choose
alias install := setup-local
alias setup := setup-local
alias ai := ai-install
alias br := git-branch
alias pr := gh-pr
alias actions := markdown-lint
alias md := markdown-lint
alias lint-actions := gh-actions-lint
alias lint-markdown := gh-actions-lint

# Default to the 'list' command, when 'just' is run without any parameters
default: list

# Show a graphical selector listing the available options and their script content
choose:
  @just --choose --justfile "{{ justfile() }}"

# Show a list of the available 'just' commands
list:
  @echo '{{ style("warning") }}Listing "just" command options from {{ justfile() }}{{ NORMAL }}'
  just --justfile "{{ justfile() }}" --list --alias-style 'right' --list-heading '' --list-prefix ''

# Setup a local environment
[group('tools')]
setup-local:
  bash ./bin/setup-local.sh || true

# Install AI Code Generation tools
[group('tools')]
ai-install:
  bash ./bin/ai-install.sh || true

# Generate release notes and save them to a file
[group('tools')]
release-notes output_file:
  bash ./bin/release-notes.sh "$output_file"

# Create a new branch from the latest version of 'develop'
[group('git')]
git-branch new_branch_name:
  just git-update
  git checkout --quiet develop
  git pull --quiet origin develop
  git checkout --quiet -b "$new_branch_name"
  git push --quiet --set-upstream origin "$new_branch_name"

# Update local Git branch statuses and Submodules
[group('git')]
git-update:
  git fetch --quiet
  git pull --quiet --recurse-submodules
  git submodule update --quiet --remote --merge

# Login to the GitHub CLI
[group('git')]
gh-login:
  gh auth login --web --git-protocol ssh --clipboard

# Create a new Pull Request for the current branch
[group('git')]
gh-pr:
  #!/usr/bin/env bash
  current_branch="$(git rev-parse --abbrev-ref HEAD)"
  target_branch="develop"
  gh pr create \
    --title "$current_branch" \
    --body-file ".github/pull_request_template.md" \
    --assignee "@me" \
    --head "$current_branch" \
    --base "$target_branch" \
    --draft

# Lint GitHub Actions Workflows
[group('tools')]
gh-actions-lint:
  gh extension install cschleiden/gh-actionlint > /dev/null 2>&1
  gh actionlint

# Lint Markdown files
[group('tools')]
markdown-lint:
  markdownlint --config ".markdownlint.yml" --fix "*.md" "docs/" "**/*.md"

# Links - Start the local Docker containers
[group('links')]
links-start:
  bash ./src/links/bin/start-links.sh

# Links - Stop the local Docker containers
[group('links')]
links-stop:
  bash ./src/links/bin/stop-links.sh

# Site - Run the build process
[group('site')]
site-build:
  cd ./src/site && deno task build

# Site - Run the Docker image build process
[group('site')]
site-docker-build:
  cd ./src/site && deno task docker-build

# Site - Start the Docker container
[group('site')]
site-docker-start:
  cd ./src/site && deno task docker-start

# Site - Stop the Docker container
[group('site')]
site-docker-stop:
  cd ./src/site && deno task docker-stop

# Site - Create a new post
[group('site')]
site-new-post:
  cd ./src/site && deno task new-post

# Site - Run the setup process
[group('site')]
site-setup:
  cd ./src/site && deno task --quiet setup

# Site - Run the local web server
[group('site')]
site-start:
  cd ./src/site && deno task serve

# Site - Run all tests
[group('site')]
site-test:
  cd ./src/site && deno task test
