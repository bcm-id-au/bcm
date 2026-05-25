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

PORT="$KARAKEEP_PORT" \
  DISABLE_SIGNUPS="$KARAKEEP_DISABLE_SIGNUPS" \
  OPENAI_API_KEY="$OPENAI_API_KEY" \
  docker compose \
  --file "$LINKS_DIR/docker-compose.local.yml" \
  up --pull always -d

echo "Karakeep started at http://localhost:3333/"
