#!/usr/bin/env bash
#
#
# Run code cleanup tools
#  - Run from src/site: deno task clean
#
#

SITE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SITE_DIR"

echo 'Applying PurgeCSS updates to site.css'

deno x --yes --no-check npm:purgecss@8.0.0 \
  --css "./src/frontend/styles/site.css" \
  --content "./src/frontend/**/*.njk" \
  --output "./src/frontend/styles/site.css" > /dev/null 2>&1

echo 'Running Deno Lint'

deno lint > /dev/null > /dev/null 2>&1

echo 'Running Deno Fmt'

deno fmt > /dev/null 2>&1
