FROM denoland/deno:latest AS build
WORKDIR /app

# Copy over the Deno config files and install
# third-party dependencies first.
COPY deno.json deno.lock ./
RUN deno task deps-install

# Copy the rest of the 'src/site' directory,
# besides items filtered out by '.dockerignore'.
COPY . .

# Set available build arguments, which can be set via Docker params:
# --build-arg SITE_POSTS_URL="https://jane-doe.com/posts/"
# --build-arg SITE_AUTHOR="Jane Doe"
# --env-file ./.staging.sample.env
ARG SITE_POSTS_DIR
ARG SITE_POSTS_URL
ARG SITE_FEED_TITLE
ARG SITE_FEED_DESC
ARG SITE_FEED_DEFAULT_TITLE
ARG SITE_LANG
ARG SITE_AUTHOR
ARG SITE_URL

# Persist build arguments as environment variables so
# resulting Docker Containers can access the values.
ENV SITE_FEED_TITLE=${SITE_FEED_TITLE}
ENV SITE_FEED_DESC=${SITE_FEED_DESC}
ENV SITE_FEED_DEFAULT_TITLE=${SITE_FEED_DEFAULT_TITLE}
ENV SITE_LANG=${SITE_LANG}
ENV SITE_AUTHOR=${SITE_AUTHOR}
ENV SITE_URL=${SITE_URL}

# Build the site
RUN deno task build

# Create a new Docker Image layer to run the site using only the static files.
# Minimises the resulting Docker Image size, speeding up build and push times.
FROM denoland/deno:latest AS serve
WORKDIR /app

# Copy over the bare minimum to serve the static files
COPY --from=build /app/public /app/public
COPY --from=build /app/deno.lock /app/deno.lock
COPY --from=build /app/deno.json /app/deno.json

EXPOSE 8000
CMD ["deno", "task", "serve"]