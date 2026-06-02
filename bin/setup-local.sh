#!/usr/bin/env bash
#
#
# Initial setup of a local environment
#  - Run directly: bash ./bin/setup-local.sh
#  - Run via Just: just setup-local
#
#

REPO="$(cd "$(dirname "$0")" && cd .. && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"

STOP_SETUP=false

if command -v brew > /dev/null 2>&1; then
  success 'Homebrew is installed'
else
  error 'Homebrew is not installed'
  STOP_SETUP=true
fi

if command -v deno > /dev/null 2>&1; then
  success 'Deno is installed'
else
  error 'Deno is not installed'
  STOP_SETUP=true
fi

if command -v docker > /dev/null 2>&1; then
  success 'Docker is installed'
else
  error 'Docker is not installed'
  STOP_SETUP=true
fi

if [ "$STOP_SETUP" = true ]; then
  error 'Cancelling setup, above tool(s) need to be installed manually'
  exit 1
fi

info 'Install: Just'
brew reinstall --force just > /dev/null 2>&1

info 'Install: GitHub CLI'
brew reinstall --force gh > /dev/null 2>&1

info 'Install: markdownlint'
brew reinstall --force markdownlint-cli > /dev/null 2>&1

info 'Running: just git-update'
just git-update

warn 'Install optional AI Code Generation tools?'
read -p '  [y/N] > ' INSTALL_AI_TOOLS
if [ "$INSTALL_AI_TOOLS" == "y" ]; then
  info 'Running: just ai-install'
  just ai-install
else
  info 'Skipped AI tools install'
fi

success 'Setup completed'
