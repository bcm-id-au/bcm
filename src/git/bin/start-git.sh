#!/usr/bin/env bash
#
#
# Start the local version of Git
#  - Run via: just git-start
#
#

REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$REPO/bin/.helper.sh"
GIT="$REPO/src/git"
cd "$GIT"

mkdir -p "$REPO/storage/git/"{app,assets,repos,database}
mkdir -p "$GIT/custom/conf"

if [ ! -f "$GIT/.git.env" ]; then
  info "Initialise file: .git.env"
  cp "$GIT/.git.local.env" "$GIT/.git.env"
fi

info "Load file: .git.env"

source "$GIT/.git.env"

info "Run: Docker Compose Up"

docker compose \
  --file "$GIT/docker-compose.local.yml" \
  --env-file "$GIT/.git.env" \
  up --pull always --build -d &&
  success "Git started at http://localhost:$PORT_WEB/"
