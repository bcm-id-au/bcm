#!/usr/bin/env bash
#
#
# Start the Docker container
#  - Run via: just site-docker-start
#
#

SITE_DIR="$(cd "$(dirname "$0")" && cd .. && pwd)"
cd "$SITE_DIR"

just site-docker-stop

docker run \
  -d \
  --name "bcm-site" \
  --publish 8000:8000 \
  --env-file "./.env" \
  "bcm-site:latest"
