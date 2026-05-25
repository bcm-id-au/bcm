# Karakeep All-In-One Docker Image Prototype

This directory prototypes a single Docker image that runs the three services from the official Karakeep Docker installation in one container:

- Karakeep app from `ghcr.io/karakeep-app/karakeep`
- Meilisearch from `getmeili/meilisearch`
- Chromium for Karakeep crawling and screenshots

The official Karakeep Docker docs use separate Compose services for the app, browser and search. This prototype keeps the same runtime dependencies, but starts them from one entrypoint for hosts that only accept a single container image.

## Files

- `Dockerfile` builds from the upstream Karakeep image, copies in Meilisearch and installs Chromium.
- `entrypoint.sh` validates required environment variables and starts Meilisearch, Chromium and Karakeep.
- `.env.example` contains the minimum runtime configuration.
- `docker-compose.yml` is a local runner for building and testing the image.

## Build

```bash
cp -n .env.example .env
docker compose build
```

Edit `.env` before running. `NEXTAUTH_SECRET` and `MEILI_MASTER_KEY` must be long random strings.

## Run

```bash
docker compose up
```

Karakeep will be available at `http://localhost:3333`.

Persistent data is mounted from the repository storage paths:

- `storage/links/app` to `/data`
- `storage/links/search` to `/meili_data`

## Direct Docker Run

```bash
docker build -t bcm-karakeep-all-in-one:0.32.0 .
docker run \
  --env-file .env \
  -p 3333:3000 \
  -v "$(pwd)/../../../../storage/links/app:/data" \
  -v "$(pwd)/../../../../storage/links/search:/meili_data" \
  bcm-karakeep-all-in-one:0.32.0
```

## Notes

- This is intentionally isolated from the existing `src/links` Compose files.
- Version pins are build args in `docker-compose.yml`.
- `MEILI_ADDR` defaults to `http://127.0.0.1:7700`.
- `BROWSER_WEB_URL` defaults to `http://127.0.0.1:9222`.
- Keep secrets in `.env`; do not bake them into the image.
