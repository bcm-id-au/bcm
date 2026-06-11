#!/usr/bin/env bash
#
#
# Local environment setup
#  - Run from src/site: deno task buid
#  - Run via Just: just site-build
#
#

SITE_DIR="$(cd "$(dirname "$0")" && cd .. && pwd)"
cd "$SITE_DIR"

if [ ! -f "$SITE_DIR/.site.env" ] && [ -f "$SITE_DIR/.site.local.env" ]; then
  echo "Initialising '.site.env' from '.site.local.env'"

  cp "$SITE_DIR/.site.local.env" "$SITE_DIR/.site.env"
fi

echo 'Installing dependencies'

deno task install
