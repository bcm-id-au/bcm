#!/usr/bin/env bash
#
#
# Run code cleanup tools
#  - Run from src/site: deno task clean
#
#

SITE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SITE_DIR"

CSS_DIR="$SITE_DIR/src/frontend/styles"
CSS_FILE_COMBINED="$SITE_DIR/src/frontend/styles/styles.css"
CSS_FILE_MINIFIED="$SITE_DIR/src/frontend/styles/styles.min.css"

echo 'Applying PurgeCSS updates to site.css'

npx purgecss \
  --css "./src/frontend/styles/site.css" \
  --content "./src/frontend/**/*.njk" \
  --output "./src/frontend/styles/site.css" > /dev/null 2>&1

echo 'Combining CSS files'

cat "$CSS_DIR/reset.css" \
  "$CSS_DIR/config.css" \
  "$CSS_DIR/site.css" \
  > "$CSS_FILE_COMBINED"

echo 'Minifying combined CSS file'

npx lightningcss-cli \
  --minify \
  --bundle \
  --targets ">= 0.25%" "$CSS_FILE_COMBINED" \
  --output-file "$CSS_FILE_MINIFIED"

echo 'Running Deno Lint'

deno lint > /dev/null > /dev/null 2>&1

echo 'Running Deno Fmt'

deno fmt > /dev/null 2>&1
