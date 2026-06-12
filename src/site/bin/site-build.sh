#!/usr/bin/env bash
#
#
# Build the site and organise the required assets
#  - Run from src/site: deno task build
#  - Run via Just: just site-build
#
#

SITE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$SITE_DIR"

# Load '.site.env' if it exists

if [ -f "$SITE_DIR/.site.env" ]; then
  echo "Loading variables from '.site.env'"

  source "$SITE_DIR/.site.env"
else
  echo "File not found at '.site.env'"
fi

# Setup the message colour characters

GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m"

# Set the temporary build directory (SITE_BUILD_DIR) and
# public output directory (SITE_PUBLIC_DIR), or set
# logical defaults if the Env Vars aren't found.

SITE_BUILD_DIR="${SITE_BUILD_DIR:-build}"
SITE_PUBLIC_DIR="${SITE_PUBLIC_DIR:-public}"

# Set the location of the source CSS directory

CSS_DIR="$SITE_DIR/src/frontend/styles"

# Clear out and recreate the Build and Public directories

echo -e "${YELLOW}Clearing the '$SITE_BUILD_DIR' directory and recreating subdirectories${NC}"

rm -rf "$SITE_BUILD_DIR"
mkdir -p "$SITE_BUILD_DIR"
mkdir -p "$SITE_BUILD_DIR/_data"
cp -r "src/frontend/templates" $SITE_BUILD_DIR/_includes
cp -r "src/frontend/layouts" $SITE_BUILD_DIR/_includes/layouts

echo -e "${YELLOW}Clearing the '$SITE_PUBLIC_DIR' directory and recreating subdirectories${NC}"

rm -rf "$SITE_PUBLIC_DIR"
mkdir -p "$SITE_PUBLIC_DIR"
mkdir -p "$SITE_PUBLIC_DIR/css"

# Format and lint code

echo -e "${YELLOW}Run code cleanup tools${NC}"

deno task clean

# Prepare content and static files

echo -e "${YELLOW}Copying over page content files to '$SITE_BUILD_DIR'${NC}"

cp -r content/* "$SITE_BUILD_DIR"

echo -e "${YELLOW}Building the front-end using Lume and 'src/frontend/lume.config.ts'${NC}"

TZ="$SITE_TIMEZONE" deno task lume > /dev/null 2>&1

# Prepare CSS files

echo 'Combining CSS files'

cat "$CSS_DIR/reset.css" \
  "$CSS_DIR/config.css" \
  "$CSS_DIR/site.css" \
  > "$SITE_BUILD_DIR/styles.css"

echo 'Minifying combined CSS file'

deno x --yes --no-check npm:lightningcss-cli@1.32.0 \
  --minify \
  --bundle \
  --targets ">= 0.25%" "$SITE_BUILD_DIR/styles.css" \
  --output-file "$SITE_PUBLIC_DIR/css/styles.min.css" # > /dev/null 2>&1

echo -e "${YELLOW}Copying FontAwesome files to '$SITE_PUBLIC_DIR/css'${NC}"

cp -r "src/frontend/styles/fontawesome" "$SITE_PUBLIC_DIR/css"

echo -e "${YELLOW}Copying static files to '$SITE_PUBLIC_DIR'${NC}"

cp -r "src/frontend/assets/fonts" "$SITE_PUBLIC_DIR/fonts"
cp -r "src/frontend/assets/images" "$SITE_PUBLIC_DIR/images"
cp "src/frontend/assets/favicon.ico" "$SITE_PUBLIC_DIR/favicon.ico"
cp "src/frontend/assets/site.webmanifest" "$SITE_PUBLIC_DIR/site.webmanifest"
cp "content/resume.pdf" "$SITE_PUBLIC_DIR/resume.pdf"

echo -e "${GREEN}Build complete${NC}"
