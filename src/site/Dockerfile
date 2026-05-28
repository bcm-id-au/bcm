FROM denoland/deno:latest AS build
WORKDIR /app

# Copy over the Deno config files and install
# third-party dependencies first.
COPY deno.json deno.lock ./
RUN deno task deps-install

# Copy the rest of the 'src/site' directory,
# besides items filtered out by '.dockerignore'.
COPY . .

# Set default build arguments based on values from '.site.local.env'.
# These can be overridden via Docker params like:
# --build-arg SITE_POSTS_URL="https://something.com/posts/"
# --build-arg SITE_AUTHOR="Jane Doe"
# --env-file ./.staging.sample.env
ARG SITE_POSTS_DIR="public/posts"
ARG SITE_POSTS_URL="https://murty.au/posts/"
ARG SITE_FEED_TITLE="Posts by Brendan Murty"
ARG SITE_FEED_DESC="Brendan is a Father, Schnitzel Reviewer, Software Engineering Manager and Technical Lead."
ARG SITE_FEED_DEFAULT_TITLE="Post by Brendan Murty"
ARG SITE_LANG="en-GB"
ARG SITE_AUTHOR="Brendan Murty"
ARG SITE_URL="https://murty.au/"
ARG SITE_FEED_FILE="public/brendan/posts.json"
ARG SITE_FEED_URL="https://murty.au/brendan/posts.json"

# Persist build arguments as environment variables so
# resulting Docker Containers can access the values.
ENV SITE_POSTS_DIR=${SITE_POSTS_DIR}
ENV SITE_POSTS_URL=${SITE_POSTS_URL}
ENV SITE_FEED_TITLE=${SITE_FEED_TITLE}
ENV SITE_FEED_DESC=${SITE_FEED_DESC}
ENV SITE_FEED_DEFAULT_TITLE=${SITE_FEED_DEFAULT_TITLE}
ENV SITE_LANG=${SITE_LANG}
ENV SITE_AUTHOR=${SITE_AUTHOR}
ENV SITE_URL=${SITE_URL}
ENV SITE_FEED_FILE=${SITE_FEED_FILE}
ENV SITE_FEED_URL=${SITE_FEED_URL}

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