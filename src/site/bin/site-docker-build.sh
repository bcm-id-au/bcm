#!/usr/bin/env bash
#
#
# Build the Docker image
#  - Run from src/site: deno task docker-build
#  - Run via Just: just site-docker-build
#
#

SITE_DIR="$(cd "$(dirname "$0")" && cd .. && pwd)"
cd "$SITE_DIR"

if [ -f "$SITE_DIR/.site.env" ]; then
  echo 'Loading vars from env file.'

  source "$SITE_DIR/.site.env"
else
  echo 'Loading vars from session.'
fi

echo "Building 'bcm-site-local' Docker Image"

docker build \
  --no-cache \
  --progress=plain \
  --tag "bcm-site-local:latest" \
  --tag "bcm-site-local:commit-$(git rev-parse --short HEAD)" \
  --build-arg SITE_FEED_TITLE="$SITE_FEED_TITLE" \
  --build-arg SITE_FEED_DESC="$SITE_FEED_DESC" \
  --build-arg SITE_FEED_DEFAULT_TITLE="$SITE_FEED_DEFAULT_TITLE" \
  --build-arg SITE_LANG="$SITE_LANG" \
  --build-arg SITE_AUTHOR="$SITE_AUTHOR" \
  --build-arg SITE_URL="$SITE_URL" \
  --build-arg SITE_POSTHOG_ID="$SITE_POSTHOG_ID" \
  --build-arg SITE_POSTHOG_REGION="$SITE_POSTHOG_REGION" \
  "."
