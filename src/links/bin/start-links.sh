#!/usr/bin/env bash
#
#
# Start the local version of Links
#  - Run via: just links-start
#
#

REPO_DIR="$(cd "$(dirname "$0")" && cd ../../.. && pwd)"
LINKS_DIR="$REPO_DIR/src/links"
cd "$LINKS_DIR"

mkdir -p "$REPO_DIR/storage/links/"{app,search}

if [ ! -f "$LINKS_DIR/.links.env" ]; then
  cp "$LINKS_DIR/.links.local.env" "$LINKS_DIR/.links.env"
fi

source "$LINKS_DIR/.links.env"

PORT="$PORT" \
  OPENAI_API_KEY="$OPENAI_API_KEY" \
  STORAGE_DIR_APP="$STORAGE_DIR_APP" \
  STORAGE_DIR_SEARCH="$STORAGE_DIR_SEARCH" \
  MEILI_MASTER_KEY="$MEILI_MASTER_KEY" \
  docker compose \
  --file "$LINKS_DIR/docker-compose.local.yml" \
  --env-file "$LINKS_DIR/.links.env" \
  up --pull always --build -d

echo "Karakeep started at http://localhost:3000/"
