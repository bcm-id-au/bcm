#!/usr/bin/env bash
#
#
# Start the Docker container
#  - Run from src/site: deno task docker-start
#  - Run via Just: just site-docker-start
#  - Port can be customised by exporting the SITE_PORT before running the script
#  - Env File Path can be customised by exporting the SITE_ENV before running the script
#
#

SITE_DIR="$(cd "$(dirname "$0")" && cd .. && pwd)"
cd "$SITE_DIR"

echo "Stopping existing 'bcm-site-local' container"

just site-docker-stop

# Load '.site.env' if it exists

if [ -f "$SITE_DIR/.site.env" ]; then
  echo "Loading variables from '.site.env'"

  source "$SITE_DIR/.site.env"
else
  echo "File not found at '.site.env'"
fi

echo "Starting 'bcm-site-local' container"

docker run \
  -d \
  --name "bcm-site-local" \
  --env-file "${SITE_ENV:-./.site.env}" \
  --publish "${SITE_PORT:-8000}:8000" \
  "bcm-site-local:latest"
