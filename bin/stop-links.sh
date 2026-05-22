#!/usr/bin/env bash

REPO="$(cd "$(dirname "$0")" && cd .. && pwd)"
DIR="$REPO/src/links"

cd "$DIR"

docker compose down
