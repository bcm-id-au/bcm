#!/usr/bin/env bash
#
#
# Stop the local version of Git
#  - Run via: just git-stop
#
#

REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$REPO/bin/.helper.sh"
GIT="$REPO/src/git"
cd "$GIT"

docker compose \
  --file "$GIT/docker-compose.local.yml" \
  down > /dev/null 2>&1 && \
  success 'Docker container stopped'

exit 0
