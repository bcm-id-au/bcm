#!/usr/bin/env bash
#
#
# Stop the Docker container
#  - Run via: just site-docker-stop
#
#

SITE_DIR="$(cd "$(dirname "$0")" && cd .. && pwd)"
cd "$SITE_DIR"

if [ "$(docker ps -aq -f name=bcm-site)" ]; then
  docker rm -f "bcm-site"
fi
