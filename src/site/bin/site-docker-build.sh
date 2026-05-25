#!/usr/bin/env bash
#
#
# Build the Docker image
#  - Run via: just site-docker-build
#
#

SITE_DIR="$(cd "$(dirname "$0")" && cd .. && pwd)"
cd "$SITE_DIR"

docker build \
  --tag "bcm-site:latest" \
  --tag "bcm-site:$(git rev-parse --short HEAD)" \
  "."
