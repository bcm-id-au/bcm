#!/usr/bin/env bash
#
#
# Start the local version of Git
#  - Run via: just git-start
#
#

REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
GIT="$REPO/src/git"
cd "$GIT"

mkdir -p "$REPO/storage/git/"{app,assets,database}
mkdir -p "$GIT/custom/conf"

if [ ! -f "$GIT/.git.env" ]; then
  cp "$GIT/.git.local.env" "$GIT/.git.env"
fi

source "$GIT/.git.env"

docker compose \
  --file "$GIT/docker-compose.local.yml" \
  --env-file "$GIT/.git.env" \
  up --pull always --build -d

echo "Git started at http://localhost:$PORT_WEB/"
