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

STOP_SETUP=false

if command -v just > /dev/null 2>&1; then
  echo '✅ Just is installed.'
else
  echo '❌ Just is not installed.'
  STOP_SETUP=true
fi

if command -v docker > /dev/null 2>&1; then
  echo '✅ Docker is installed.'
else
  echo '❌ Docker is not installed.'
  STOP_SETUP=true
fi

if command -v deno > /dev/null 2>&1; then
  echo '✅ Deno is installed.'
else
  echo '❌ Deno is not installed.'
  STOP_SETUP=true
fi

if command -v brew > /dev/null 2>&1; then
  echo '✅ Homebrew is installed.'
else
  echo '❌ Homebrew is not installed.'
  STOP_SETUP=true
fi

if command -v gh > /dev/null 2>&1; then
  echo '✅ GitHub CLI is installed.'
else
  echo '❌ GitHub CLI is not installed.'
  STOP_SETUP=true
fi

if [ "$STOP_SETUP" = true ]; then
  echo '⚠️ Cancelling setup, some required tools need to be installed manually.'
  exit 1
fi

echo "⏳ Running 'just git-update'"
just git-update

echo "⏳ Running 'just gh-login'"
just gh-login

read -p "🤖 Do you also want to install AI Code Generation tools? (y/n) " install_ai_tools
if [ "$install_ai_tools" == "y" ]; then
  echo "⏳ Running 'just ai-install'"
  just ai-install
fi
