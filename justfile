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
alias br := git-branch
alias pr := gh-pr

# Default to the 'list' command, when 'just' is run without any parameters
default: list

# Show a graphical selector listing the available options and their script content
choose:
  @just --choose --justfile "{{ justfile() }}"

# Show a list of the available 'just' commands
list:
  @echo '{{ style("warning") }}Listing "just" command options from {{ justfile() }}{{ NORMAL }}'
  just --justfile "{{ justfile() }}" --list --alias-style 'right' --list-heading '' --list-prefix ''

# Initial setup for local environments
[group('tools')]
setup:
  bash ./bin/setup.sh

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

# Lint GitHub Actions Workflows
[group('git')]
gh-actions-lint:
  gh extension install cschleiden/gh-actionlint
  gh actionlint

# Start the local instance of Links
[group('links')]
links-start:
  bash ./src/links/bin/start-links.sh

# Stop the local instance of Links
[group('links')]
links-stop:
  bash ./src/links/bin/stop-links.sh

# Run the build process for Site
[group('site')]
site-build:
  bash ./src/site/bin/site-build.sh

# Run the Docker image build process for Site
[group('site')]
site-docker-build:
  bash ./src/site/bin/site-docker-build.sh

# Start the Docker container for Site
[group('site')]
site-docker-start:
  bash ./src/site/bin/site-docker-start.sh

# Stop the Docker container for Site
[group('site')]
site-docker-stop:
  bash ./src/site/bin/site-docker-stop.sh

# Create a new post for Site
[group('site')]
site-new-post:
  bash ./src/site/bin/site-new-post.sh

# Run the setup process for Site
[group('site')]
site-setup:
  bash ./src/site/bin/site-setup.sh

# Run a local version of Site
[group('site')]
site-start:
  cd ./src/site && deno task serve

# Run tests for Site
[group('site')]
site-test:
  cd ./src/site && deno task test
