#!/usr/bin/env bash
#
#
# Start the static file server
#  - Run via: just site-start
#
#

SITE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SITE_DIR"

# Run the static file web server

TZ=${SITE_TIMEZONE:-"Australia/Sydney"} deno run \
	--allow-net --allow-read --allow-env \
	./src/server/server.ts
