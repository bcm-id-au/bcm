FROM denoland/deno:latest AS build
WORKDIR /app

COPY bin/site ./bin/site
COPY src/site ./src/site

WORKDIR /app/src/site

RUN deno task setup
RUN deno task build

FROM denoland/deno:latest AS serve
WORKDIR /app/src/site

COPY --from=build /app/src/site/deno.json ./deno.json
COPY --from=build /app/src/site/deno.lock ./deno.lock
COPY --from=build /app/src/site/public ./public

RUN deno cache --no-config jsr:@std/http/file-server

EXPOSE 8080
CMD ["sh", "-c", "deno run --no-config --allow-net --allow-read jsr:@std/http/file-server ./public --port ${PORT:-8080}"]
