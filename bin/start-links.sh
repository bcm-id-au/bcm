#!/usr/bin/env bash

REPO="$(cd "$(dirname "$0")" && cd .. && pwd)"
DIR="$REPO/src/links"

mkdir -p "$REPO/storage/links/"{app,search}

cd "$DIR"

cp -n .links.sample.env .links.env
source .links.env

PORT="$KARAKEEP_PORT" \
  DISABLE_SIGNUPS="$KARAKEEP_DISABLE_SIGNUPS" \
  OPENAI_API_KEY="$OPENAI_API_KEY" \
  docker compose \
  --file "$DIR/docker-compose.local.yml" \
  up -d

echo "Karakeep started at http://localhost:3333/"
