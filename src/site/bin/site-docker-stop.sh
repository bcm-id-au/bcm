#!/usr/bin/env bash
#
#
# Stop the Docker container
#  - Run from src/site: deno task docker-stop
#  - Run via Just: just site-docker-stop
#
#

SITE_DIR="$(cd "$(dirname "$0")" && cd .. && pwd)"
cd "$SITE_DIR"

if [ "$(docker ps -aq -f name=bcm-site-local)" ]; then
  echo "Stopping and removing 'bcm-site-local' container"

  docker stop "bcm-site-local" >/dev/null 2>&1
  docker rm "bcm-site-local" >/dev/null 2>&1
fi
