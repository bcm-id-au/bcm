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

echo -e "${YELLOW}Running Deno Lint and Deno Format${NC}"

deno task lint > /dev/null 2>&1

# Start the build process

echo -e "${YELLOW}Clearing the '$SITE_PUBLIC_DIR' directory and recreating subdirectories${NC}"

rm -rf "$SITE_PUBLIC_DIR"
mkdir -p "$SITE_PUBLIC_DIR"

echo -e "${YELLOW}Clearing the '$SITE_BUILD_DIR' directory and recreating subdirectories${NC}"

rm -rf "$SITE_BUILD_DIR"
mkdir -p "$SITE_BUILD_DIR"
mkdir -p "$SITE_BUILD_DIR/_data"
cp -r "src/frontend/styles" $SITE_BUILD_DIR/_styles
cp -r "src/frontend/templates" $SITE_BUILD_DIR/_includes
cp -r "src/frontend/layouts" $SITE_BUILD_DIR/_includes/layouts

echo -e "${YELLOW}Combining CSS files${NC}"

mkdir -p $SITE_BUILD_DIR/_assets/css
cat $SITE_BUILD_DIR/_styles/tools-reset.css $SITE_BUILD_DIR/_styles/site.css $SITE_BUILD_DIR/_styles/media-screen-medium.css $SITE_BUILD_DIR/_styles/media-screen-small.css $SITE_BUILD_DIR/_styles/media-print.css > $SITE_BUILD_DIR/_assets/css/styles.css

echo -e "${YELLOW}Minifying combined CSS file${NC}"

cat "$SITE_BUILD_DIR/_assets/css/styles.css" | \
sed -e 's/^[ \t]*//g; s/[ \t]*$//g; s/\([:{;,]\) /\1/g; s/ {/{/g; s/\/\*.*\*\///g; /^$/d' | sed -e :a -e '$!N; s/\n\(.\)/\1/; ta' | tr '\n' ' ' > $SITE_BUILD_DIR/_assets/css/styles.min.css

echo -e "${YELLOW}Copying over page content files to '$SITE_BUILD_DIR'${NC}"

cp -r content/* "$SITE_BUILD_DIR"
rm -rf "$SITE_BUILD_DIR/content/resume.pdf"

echo -e "${YELLOW}Building the front-end using Lume and 'src/lume.config.ts'${NC}"

TZ="$SITE_TIMEZONE" deno task lume > /dev/null 2>&1

echo -e "${YELLOW}Copying static files to '$SITE_PUBLIC_DIR'${NC}"

cp -r "src/frontend/assets/fonts" "$SITE_PUBLIC_DIR/fonts"
cp -r "src/frontend/assets/images" "$SITE_PUBLIC_DIR/images"
cp "src/frontend/assets/favicon.ico" "$SITE_PUBLIC_DIR/favicon.ico"
cp "src/frontend/assets/site.webmanifest" "$SITE_PUBLIC_DIR/site.webmanifest"
cp "content/resume.pdf" "$SITE_PUBLIC_DIR/resume.pdf"

echo -e "${YELLOW}Copying CSS files to '$SITE_PUBLIC_DIR/css'${NC}"

mkdir -p "$SITE_PUBLIC_DIR/css"
cp "$SITE_BUILD_DIR/_assets/css/styles.min.css" "$SITE_PUBLIC_DIR/css/styles.min.css"

cp -r "src/frontend/styles/fontawesome" "$SITE_PUBLIC_DIR/css"

echo -e "${YELLOW}Deleting '$SITE_BUILD_DIR'${NC}"

rm -rf "$SITE_BUILD_DIR"

echo -e "${GREEN}Build complete${NC}"
