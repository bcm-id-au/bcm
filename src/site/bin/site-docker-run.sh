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
  --name "bcm-site" \
  --env-file "./.env" \
  "bcm-site:latest"
