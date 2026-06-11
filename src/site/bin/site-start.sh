#!/usr/bin/env bash
#
#
# Start the static file server
#  - Run from src/site: deno task start
#  - Run via Just: just site-start
#
#

SITE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SITE_DIR"

TZ=${SITE_TIMEZONE:-"Australia/Sydney"} deno run \
	--allow-net --allow-read --allow-env \
	./src/backend/server.ts
