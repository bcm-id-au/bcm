#!/usr/bin/env bash
#
#
# Start the Docker container
#  - Run via: just site-docker-start
#  - Port can be customised by exporting the SITE_PORT before running the script
#  - Env File Path can be customised by exporting the SITE_ENV before running the script
#
#

SITE_DIR="$(cd "$(dirname "$0")" && cd .. && pwd)"
cd "$SITE_DIR"

just site-docker-stop

echo "Starting 'bcm-site-local' container"

docker run \
  -d \
  --name "bcm-site-local" \
  --publish "${SITE_PORT:-8000}:8000" \
  --env-file "${SITE_ENV:-./.site.env}" \
  "bcm-site-local:latest"
