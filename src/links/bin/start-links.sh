#!/usr/bin/env bash
#
#
# Start the local version of Links
#  - Run via: just links-start
#
#

REPO_DIR="$(cd "$(dirname "$0")" && cd ../../.. && pwd)"
LINKS_DIR="$REPO_DIR/src/links"

mkdir -p "$REPO_DIR/storage/links/"{app,search}

cd "$LINKS_DIR"
cp -n .links.sample.env .links.env
source .links.env

PORT="$PORT" \
  OPENAI_API_KEY="$OPENAI_API_KEY" \
  STORAGE_DIR_APP="$STORAGE_DIR_APP" \
  STORAGE_DIR_SEARCH="$STORAGE_DIR_SEARCH" \
  MEILI_MASTER_KEY="$MEILI_MASTER_KEY" \
  docker compose \
  --file "$LINKS_DIR/docker-compose.yml" \
  up --pull always --build -d

echo "Karakeep started at http://localhost:3000/"
