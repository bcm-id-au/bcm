FROM denoland/deno:latest
WORKDIR /app

COPY . .

# TODO: this needs to securely load in '.env' without including it in the Docker image

RUN deno task setup
RUN deno task build

EXPOSE 8000
CMD ["deno", "task", "serve"]