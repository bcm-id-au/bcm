#!/usr/bin/env bash

LINKS_DIR="$(cd "$(dirname "$0")" && cd ../src/links && pwd)"

cd "$LINKS_DIR"

docker compose down
