#!/usr/bin/env bash
#
#
# Install AI Code Generation tools
#  - Run directly: bash ./bin/ai-install.sh
#  - Run via Just: just ai-install
#  - Uses the first-party suggested installation and update methods for Linux/macOS
#
#

REPO="$(cd "$(dirname "$0")" && cd .. && pwd)"
cd "$REPO"
source "$REPO/bin/.helper.sh"

info 'Install: Google Antigravity CLI'
curl -fsSL https://antigravity.google/cli/install.sh | bash > /dev/null 2>&1

info 'Running: agy update'
agy update > /dev/null 2>&1

info 'Install: OpenAI Codex CLI'
brew reinstall --force codex > /dev/null 2>&1

info 'Install: Claude Code CLI'
curl -fsSL https://claude.ai/install.sh | bash > /dev/null 2>&1

info 'Running: claude update'
claude update > /dev/null 2>&1

info 'Install: GitHub Copilot CLI'
curl -fsSL https://gh.io/copilot-install | bash > /dev/null 2>&1

info 'Running: copilot update'
copilot update > /dev/null 2>&1
