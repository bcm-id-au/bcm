FROM denoland/deno:alpine AS build
WORKDIR /app

# Install Bash
RUN apk add --no-cache bash

# Change DENO_DIR to avoid conflicts with Google Cloud
RUN mkdir -p /app/.deno_cache
ENV DENO_DIR=/app/.deno_cache

# Copy over the Deno config files and install
# third-party dependencies first.
COPY deno.jsonc /app
COPY deno.lock /app
COPY bin /app/bin
RUN deno task --quiet setup

# Copy the rest of the 'src/site' directory,
# besides items filtered out by '.dockerignore'.
COPY . .

# Define build arguments, set via Docker Build parameters like:
#   --build-arg SITE_AUTHOR="Jane Doe"
#   --env-file ./.staging.sample.env
ARG SITE_BUILD_DIR
ARG SITE_PUBLIC_DIR
ARG SITE_AUTHOR
ARG SITE_TITLE
ARG SITE_DESC
ARG SITE_REPO
ARG SITE_URL
ARG SITE_LANG
ARG SITE_FEED_TITLE
ARG SITE_FEED_DESC
ARG SITE_FEED_DEFAULT_TITLE

# Persist build arguments as environment variables so
# resulting Docker Containers can access the values.
ENV SITE_BUILD_DIR=${SITE_BUILD_DIR}
ENV SITE_PUBLIC_DIR=${SITE_PUBLIC_DIR}
ENV SITE_AUTHOR=${SITE_AUTHOR}
ENV SITE_TITLE=${SITE_TITLE}
ENV SITE_DESC=${SITE_DESC}
ENV SITE_REPO=${SITE_REPO}
ENV SITE_URL=${SITE_URL}
ENV SITE_LANG=${SITE_LANG}
ENV SITE_FEED_TITLE=${SITE_FEED_TITLE}
ENV SITE_FEED_DESC=${SITE_FEED_DESC}
ENV SITE_FEED_DEFAULT_TITLE=${SITE_FEED_DEFAULT_TITLE}

# Set Docker Image properties
# From: https://github.com/opencontainers/image-spec/blob/main/annotations.md
LABEL maintainer=$SITE_AUTHOR
LABEL org.opencontainers.image.title=$SITE_TITLE
LABEL org.opencontainers.image.description=$SITE_DESC
LABEL org.opencontainers.image.authors=$SITE_AUTHOR
LABEL org.opencontainers.image.vendor=$SITE_AUTHOR
LABEL org.opencontainers.image.url=$SITE_REPO
LABEL org.opencontainers.image.source=$SITE_REPO
LABEL org.opencontainers.image.licenses=MIT

# Build the site
RUN deno task build

# Create a new Docker Image layer to run the site using only the static files.
# Minimises the resulting Docker Image size, speeding up build and push times.
FROM denoland/deno:alpine AS serve
WORKDIR /app

# Install Bash
RUN apk add --no-cache bash

# Copy over the bare minimum to serve the static files
COPY --from=build /app/bin /app/bin
COPY --from=build /app/src/server /app/src/server
COPY --from=build /app/public /app/public
COPY --from=build /app/deno.lock /app/deno.lock
COPY --from=build /app/deno.jsonc /app/deno.jsonc

# Start the server as a non-root user on port 8000
USER deno
EXPOSE 8000
CMD ["deno", "task", "start"]