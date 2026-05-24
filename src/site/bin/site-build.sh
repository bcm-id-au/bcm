#!/usr/bin/env bash
#
#
# Build the site and organise the required assets
#  - Run via: just site-build
#
#

SITE_DIR="$(cd "$(dirname "$0")" && cd .. && pwd)"
cd "$SITE_DIR"

# Setup the message colour characters

GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m"

# Define the temporary build directory (BUILD_DIR) and public output directory (PUBLIC_DIR)

BUILD_DIR="build"
PUBLIC_DIR="public"

# Set the production domain and link

PROD_DOMAIN="murty.au"
PROD_LINK="https://$PROD_DOMAIN"

# Format and lint code

echo -e "${YELLOW}Running Deno Lint and Deno Format${NC}"

deno task lint

# Start the build process

echo -e "${YELLOW}Clearing the '$PUBLIC_DIR' directory and recreating subdirectories${NC}"

rm -rf "$PUBLIC_DIR"
mkdir -p "$PUBLIC_DIR"

echo -e "${YELLOW}Clearing the '$BUILD_DIR' directory and recreating subdirectories${NC}"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
mkdir -p "$BUILD_DIR/_data"
cp -r "src/styles" $BUILD_DIR/_styles
cp -r "src/templates" $BUILD_DIR/_includes
cp -r "src/layouts" $BUILD_DIR/_includes/layouts

echo -e "${YELLOW}Combining CSS files${NC}"

mkdir -p $BUILD_DIR/_assets/css
cat $BUILD_DIR/_styles/tools-reset.css $BUILD_DIR/_styles/site.css $BUILD_DIR/_styles/media-screen-medium.css $BUILD_DIR/_styles/media-screen-small.css $BUILD_DIR/_styles/media-print.css > $BUILD_DIR/_assets/css/styles.css

echo -e "${YELLOW}Minifying combined CSS file${NC}"

cat "$BUILD_DIR/_assets/css/styles.css" | \
sed -e 's/^[ \t]*//g; s/[ \t]*$//g; s/\([:{;,]\) /\1/g; s/ {/{/g; s/\/\*.*\*\///g; /^$/d' | sed -e :a -e '$!N; s/\n\(.\)/\1/; ta' | tr '\n' ' ' > $BUILD_DIR/_assets/css/styles.min.css

echo -e "${YELLOW}Copying over page content files to '$BUILD_DIR'${NC}"

cp -r content/* "$BUILD_DIR"

echo -e "${YELLOW}Building the front-end using Lume and '_config.ts'${NC}"

deno task lume

echo -e "${YELLOW}Updating '$PUBLIC_DIR/sitemap.xml' to use the production URL${NC}"

sed -i -e "s/http:\/\/localhost\//https:\/\/$PROD_DOMAIN\//g" "$PUBLIC_DIR/sitemap.xml"

echo -e "${YELLOW}Updating '$PUBLIC_DIR/robots.txt' to use the production URL${NC}"

sed -i -e "s/http:\/\/localhost\//https:\/\/$PROD_DOMAIN\//g" "$PUBLIC_DIR/robots.txt"

echo -e "${YELLOW}Configuring GitHub Pages in '$PUBLIC_DIR'${NC}"

# Custom 404 page
cp "assets/redirect.html" "$PUBLIC_DIR/404.html"

echo -e "${YELLOW}Copying static files to '$PUBLIC_DIR'${NC}"

cp -r "assets/fonts" "$PUBLIC_DIR/fonts"
cp -r "assets/images" "$PUBLIC_DIR/images"
cp "assets/favicon.ico" "$PUBLIC_DIR/favicon.ico"
cp "site.webmanifest" "$PUBLIC_DIR/site.webmanifest"

echo -e "${YELLOW}Copying CSS files to '$PUBLIC_DIR/css'${NC}"

mkdir -p "$PUBLIC_DIR/css"
cp "$BUILD_DIR/_assets/css/styles.min.css" "$PUBLIC_DIR/css/styles.min.css"

cp -r "src/styles/fontawesome" "$PUBLIC_DIR/css"

echo -e "${YELLOW}Building a JSON Feed with posts data${NC}"

mkdir -p "$PUBLIC_DIR/brendan"
deno task json-feed

echo -e "${YELLOW}Deleting '$BUILD_DIR'${NC}"

rm -rf "$BUILD_DIR"

echo -e "${GREEN}Build complete${NC}"
