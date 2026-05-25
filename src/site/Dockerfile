FROM denoland/deno:latest
WORKDIR /app

# Copy dependency files first for layer caching
COPY deno.json deno.lock ./
RUN deno task deps-install

# Copy the rest of the application source,
# besides those filtered out by .dockerignore
COPY . .

# Build args for site config (pass via --build-arg or --env-file)
# Defaults align with .env.sample — override for your deployment
ARG BLOG_POSTS_DIR=public/posts
ARG BLOG_POSTS_URL=https://murty.au/posts/
ARG JSON_FEED_VERSION_URL=https://jsonfeed.org/version/1.1
ARG JSON_FEED_TITLE="Posts by Brendan Murty"
ARG JSON_FEED_DESCRIPTION="Brendan is a Father, Schnitzel Reviewer, Software Engineering Manager and Technical Lead."
ARG JSON_FEED_DEFAULT_POST_TITLE="Post by Brendan Murty"
ARG JSON_FEED_LANGUAGE=en-GB
ARG JSON_FEED_AUTHOR_NAME="Brendan Murty"
ARG JSON_FEED_AUTHOR_URL=https://murty.au/
ARG JSON_FEED_FILE_OUTPUT=public/brendan/posts.json
ARG JSON_FEED_URL_FEED=https://murty.au/brendan/posts.json

# Persist build args as env vars for the build step (and runtime, if needed)
ENV BLOG_POSTS_DIR=${BLOG_POSTS_DIR}
ENV BLOG_POSTS_URL=${BLOG_POSTS_URL}
ENV JSON_FEED_VERSION_URL=${JSON_FEED_VERSION_URL}
ENV JSON_FEED_TITLE=${JSON_FEED_TITLE}
ENV JSON_FEED_DESCRIPTION=${JSON_FEED_DESCRIPTION}
ENV JSON_FEED_DEFAULT_POST_TITLE=${JSON_FEED_DEFAULT_POST_TITLE}
ENV JSON_FEED_LANGUAGE=${JSON_FEED_LANGUAGE}
ENV JSON_FEED_AUTHOR_NAME=${JSON_FEED_AUTHOR_NAME}
ENV JSON_FEED_AUTHOR_URL=${JSON_FEED_AUTHOR_URL}
ENV JSON_FEED_FILE_OUTPUT=${JSON_FEED_FILE_OUTPUT}
ENV JSON_FEED_URL_FEED=${JSON_FEED_URL_FEED}

RUN deno task build

EXPOSE 8000
CMD ["deno", "task", "serve"]