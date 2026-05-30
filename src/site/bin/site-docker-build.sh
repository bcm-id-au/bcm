#!/usr/bin/env bash
#
#
# Build the Docker image
#  - Run via: just site-docker-build
#
#

SITE_DIR="$(cd "$(dirname "$0")" && cd .. && pwd)"
cd "$SITE_DIR"

if [ -f "$SITE_DIR/.site.env" ]; then
  echo 'Loading environment vars from file.'

  source "$SITE_DIR/.site.env"
fi

echo 'Building Docker image using environment vars from the Terminal session.'

docker build \
  --tag "bcm-site:latest" \
  --tag "bcm-site:$(git rev-parse --short HEAD)" \
  --progress=plain \
  --build-arg SITE_POSTS_DIR="$SITE_POSTS_DIR" \
  --build-arg SITE_POSTS_URL="$SITE_POSTS_URL" \
  --build-arg SITE_FEED_TITLE="$SITE_FEED_TITLE" \
  --build-arg SITE_FEED_DESC="$SITE_FEED_DESC" \
  --build-arg SITE_FEED_DEFAULT_TITLE="$SITE_FEED_DEFAULT_TITLE" \
  --build-arg SITE_LANG="$SITE_LANG" \
  --build-arg SITE_AUTHOR="$SITE_AUTHOR" \
  --build-arg SITE_URL="$SITE_URL" \
  --build-arg SITE_FEED_FILE="$SITE_FEED_FILE" \
  --build-arg SITE_FEED_URL="$SITE_FEED_URL" \
  "."
