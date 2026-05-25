ARG KARAKEEP_VERSION=0.32.0
ARG MEILISEARCH_VERSION=v1.41.0

FROM getmeili/meilisearch:${MEILISEARCH_VERSION} AS meilisearch

FROM ghcr.io/karakeep-app/karakeep:${KARAKEEP_VERSION}

USER root

RUN set -eux; \
  if command -v apk >/dev/null 2>&1; then \
    apk add --no-cache bash chromium; \
  elif command -v apt-get >/dev/null 2>&1; then \
    apt-get update; \
    apt-get install -y --no-install-recommends bash chromium ca-certificates musl; \
    apt-get clean; \
  else \
    echo "Unsupported Karakeep base image: neither apk nor apt-get is available" >&2; \
    exit 1; \
  fi

COPY --from=meilisearch /bin/meilisearch /usr/local/bin/meilisearch
COPY entrypoint.sh /usr/local/bin/bcm-links

RUN chmod 0755 /usr/local/bin/bcm-links

ENV DATA_DIR=/data \
  MEILI_ADDR=http://127.0.0.1:7700 \
  MEILI_DB_PATH=/meili_data \
  MEILI_NO_ANALYTICS=true \
  BROWSER_WEB_URL=http://127.0.0.1:9222 \
  DISABLE_SIGNUPS=true

VOLUME ["/data", "/meili_data"]
EXPOSE 3000

ENTRYPOINT ["/usr/local/bin/bcm-karakeep-all-in-one"]
