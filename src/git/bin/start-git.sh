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

if [ -f "$GIT/.git.env" ]; then
  echo "Loading variables from '.git.env'"

  source "$GIT/.git.env"

  info "Run: Docker Compose Up"

  export USER_UID="$(id -u)" && \
    export USER_GID="$(id -g)" && \
    docker compose \
      --file "$GIT/docker-compose.local.yml" \
      --env-file "$GIT/.git.env" \
      up \
      --pull always \
      --build \
      -d && \
    success "Git started at http://localhost:$PORT_WEB/"
else
  echo "File not found at '.git.env'"
  echo "Run: Docker Compose Up"

  export USER_UID="$(id -u)" && \
    export USER_GID="$(id -g)" && \
    docker compose \
      --file "$GIT/docker-compose.local.yml" \
      up \
      --pull always \
      --build \
      -d && \
    success "Git started at http://localhost:$PORT_WEB/"
fi
