#!/usr/bin/env bash
#
#
# Stop the local version of Git
#  - Run via: just git-stop
#
#

GIT="$(cd "$(dirname "$0")" && cd .. && pwd)"
cd "$GIT"

docker compose \
  --file "$GIT/docker-compose.local.yml" \
  down > /dev/null 2>&1

exit 0
