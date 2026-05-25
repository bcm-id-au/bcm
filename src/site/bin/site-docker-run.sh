#!/usr/bin/env bash
#
#
# Run a Docker image
#  - Run via: just xxxxxxxxxxxxxxxxxxxxx
#
#

SITE_DIR="$(cd "$(dirname "$0")" && cd .. && pwd)"
cd "$SITE_DIR"

docker run \
  -d \
  --name "bcm-site" \
  --publish 8000:8000 \
  --rm \
  --env-file "./.env" \
  "bcm-site:latest"
