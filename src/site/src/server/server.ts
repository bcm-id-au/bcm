import { load } from "@std/dotenv";

import Server from "lume/core/server.ts";
import notFound from "lume/middlewares/not_found.ts";
import logger from "lume/middlewares/logger.ts";

// Load variables from the ENV file

const appEnv = Deno.env.get("SITE_ENV") || "other";
const isLocal = appEnv === "local";

if (isLocal) {
  console.log("Loading variables from '.site.env'");

  await load({
    envPath: ".site.env",
    export: true,
  });
}

const appPort = Number(Deno.env.get("SITE_PORT")) || 8000;
const appPublic = Deno.env.get("SITE_PUBLIC_DIR") || "public";

// Configure the server
const server = new Server({
  port: appPort,
  root: `./${appPublic}`,
});

// Log request summary items to the console
server.use(logger());

// Send all 404 requests to a redirect file
server.use(notFound({
  root: `./${appPublic}`,
  page404: "/404.html",
}));

// Start the server
server.start();
console.log(
  `%c[${appEnv}, ${isLocal ? "local" : "hosted"}] Server started on port ${appPort}`,
  "color:green",
);
