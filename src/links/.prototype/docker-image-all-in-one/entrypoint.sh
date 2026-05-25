#!/usr/bin/env bash
set -Eeuo pipefail

log() {
  printf '[bcm-karakeep-all-in-one] %s\n' "$*"
}

fail() {
  log "ERROR: $*"
  exit 1
}

require_env() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    fail "$name must be set"
  fi
}

find_chromium() {
  local candidate
  for candidate in chromium chromium-browser google-chrome google-chrome-stable; do
    if command -v "$candidate" >/dev/null 2>&1; then
      command -v "$candidate"
      return 0
    fi
  done

  return 1
}

require_env NEXTAUTH_SECRET
require_env NEXTAUTH_URL
require_env MEILI_MASTER_KEY

DATA_DIR="${DATA_DIR:-/data}"
MEILI_DB_PATH="${MEILI_DB_PATH:-/meili_data}"
MEILI_ADDR="${MEILI_ADDR:-http://127.0.0.1:7700}"
BROWSER_WEB_URL="${BROWSER_WEB_URL:-http://127.0.0.1:9222}"
MEILI_NO_ANALYTICS="${MEILI_NO_ANALYTICS:-true}"

export DATA_DIR
export MEILI_DB_PATH
export MEILI_ADDR
export BROWSER_WEB_URL
export MEILI_NO_ANALYTICS

mkdir -p "$DATA_DIR" "$MEILI_DB_PATH"

log "starting meilisearch at $MEILI_ADDR"
meilisearch \
  --http-addr "127.0.0.1:7700" \
  --db-path "$MEILI_DB_PATH" &

chromium_bin="$(find_chromium)" || fail "chromium is not installed in the image"

log "starting chromium remote debugging at $BROWSER_WEB_URL"
"$chromium_bin" \
  --headless=new \
  --no-sandbox \
  --disable-gpu \
  --disable-dev-shm-usage \
  --remote-debugging-address=0.0.0.0 \
  --remote-debugging-port=9222 \
  --hide-scrollbars \
  about:blank &

if [[ "$#" -eq 0 ]]; then
  if [[ -x /init ]]; then
    set -- /init
  else
    fail "no Karakeep command was provided and /init was not found"
  fi
fi

log "starting karakeep"
exec "$@"
