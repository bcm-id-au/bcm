#!/usr/bin/env bash
#
#
# Setup directories, check for and install dependencies, used for local environments and in CI
#  - Run via: just site-setup
#
#

SITE_DIR="$(cd "$(dirname "$0")" && cd .. && pwd)"
cd "$SITE_DIR"

# Recreate build directories

rm -rf "./build"
mkdir -p "./build"

rm -rf "./public"
mkdir -p "./public"

# Setup an initial ENV file if it doesn't already exist

if [ ! -f ./.site.env ]; then
  cp ./.site.sample.env ./.site.env
fi

# Install dependencies

deno task deps-install
