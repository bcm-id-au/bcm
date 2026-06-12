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

# Define the temporary build directory (SITE_BUILD_DIR) and public output directory (SITE_PUBLIC_DIR),
# defaulting to using the ENV var if it exists already

SITE_BUILD_DIR=${SITE_BUILD_DIR:-"build"}
SITE_PUBLIC_DIR=${SITE_PUBLIC_DIR:-"public"}

# Set the production URL

PROD_LINK=${SITE_URL:-"https://murty.au"}
PROD_LINK_REGEX=${PROD_LINK//\//\\/}

# Format and lint code

echo -e "${YELLOW}Run code cleanup tools${NC}"

deno task clean

# Start the build process

echo -e "${YELLOW}Clearing the '$SITE_PUBLIC_DIR' directory and recreating subdirectories${NC}"

rm -rf "$SITE_PUBLIC_DIR"
mkdir -p "$SITE_PUBLIC_DIR"

echo -e "${YELLOW}Clearing the '$SITE_BUILD_DIR' directory and recreating subdirectories${NC}"

rm -rf "$SITE_BUILD_DIR"
mkdir -p "$SITE_BUILD_DIR"
mkdir -p "$SITE_BUILD_DIR/_data"
cp -r "src/frontend/templates" $SITE_BUILD_DIR/_includes
cp -r "src/frontend/layouts" $SITE_BUILD_DIR/_includes/layouts

echo -e "${YELLOW}Copying over page content files to '$SITE_BUILD_DIR'${NC}"

cp -r content/* "$SITE_BUILD_DIR"
rm -rf "$SITE_BUILD_DIR/content/resume.pdf"

echo -e "${YELLOW}Building the front-end using Lume and 'src/frontend/lume.config.ts'${NC}"

TZ="$SITE_TIMEZONE" deno task lume > /dev/null 2>&1

echo -e "${YELLOW}Copying static files to '$SITE_PUBLIC_DIR'${NC}"

cp -r "src/frontend/assets/fonts" "$SITE_PUBLIC_DIR/fonts"
cp -r "src/frontend/assets/images" "$SITE_PUBLIC_DIR/images"
cp "src/frontend/assets/favicon.ico" "$SITE_PUBLIC_DIR/favicon.ico"
cp "src/frontend/assets/site.webmanifest" "$SITE_PUBLIC_DIR/site.webmanifest"
cp "content/resume.pdf" "$SITE_PUBLIC_DIR/resume.pdf"

echo -e "${YELLOW}Copying minified combined CSS file to '$SITE_PUBLIC_DIR/css'${NC}"

mkdir -p "$SITE_PUBLIC_DIR/css"
cp "src/frontend/styles/styles.min.css" "$SITE_PUBLIC_DIR/css/styles.min.css"

cp -r "src/frontend/styles/fontawesome" "$SITE_PUBLIC_DIR/css"

echo -e "${YELLOW}Deleting '$SITE_BUILD_DIR'${NC}"

rm -rf "$SITE_BUILD_DIR"

echo -e "${GREEN}Build complete${NC}"
