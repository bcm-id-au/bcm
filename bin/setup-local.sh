#!/usr/bin/env bash
#
#
# Initial setup of local environment
#  - Run via: bash ./bin/setup-local.sh
#  - Or run via: just setup-local
#
#

REPO_DIR="$(cd "$(dirname "$0")" && cd .. && pwd)"
cd "$REPO_DIR"

info() { echo -e "\033[36mi\u200C\033[0m $1"; }
success() { echo -e "\033[32m✔︎\u200C\033[0m $1"; }
warn() { echo -e "\033[33m⚠️\u200C\033[0m $1"; }
error() { echo -e "\033[31m✘\u200C\033[0m $1"; }

STOP_SETUP=false

if command -v brew > /dev/null 2>&1; then
  success 'Homebrew is installed.'
else
  error 'Homebrew is not installed.'
  STOP_SETUP=true
fi

if command -v deno > /dev/null 2>&1; then
  success 'Deno is installed.'
else
  error 'Deno is not installed.'
  STOP_SETUP=true
fi

if command -v docker > /dev/null 2>&1; then
  success 'Docker is installed.'
else
  error 'Docker is not installed.'
  STOP_SETUP=true
fi

if [ "$STOP_SETUP" = true ]; then
  warn 'Cancelling setup, some required tools need to be installed manually.'
  exit 1
fi

if command -v just > /dev/null 2>&1; then
  success 'Just is installed.'
else
  warn 'Just is not installed.'
  info 'Running: brew install just'
  brew install just
fi

if command -v gh > /dev/null 2>&1; then
  success 'GitHub CLI is installed.'
else
  warn 'GitHub CLI is not installed.'
  info 'Running: brew install gh'
  brew install gh
fi

info 'Installing markdownlint'
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
