import { load } from "@std/dotenv";

import Server from "lume/core/server.ts";
import notFound from "lume/middlewares/not_found.ts";
import logger from "lume/middlewares/logger.ts";

// Load variables from the ENV file

try {
  await load({
    envPath: ".site.env",
    export: true,
  });

  console.info("Loaded ENV vars from local file.");
} catch (_error) {
  console.warn("Using system ENV vars.");
}

const appEnv = Deno.env.get("SITE_ENV") || "other";
const appPort = Number(Deno.env.get("SITE_PORT")) || 8000;
const appPublic = Deno.env.get("SITE_PUBLIC_DIR") || "public";

const isLocal = Boolean(Deno.env.get("SITE_ENV") === "local");

// Configure the server
const server = new Server({
  port: appPort,
  root: `./${appPublic}`,
});

// Log requests to the console on local environments
if (isLocal) {
  server.use(logger());
}

// Send all 404 requests to a redirect file
server.use(notFound({
  root: `./${appPublic}`,
  page404: "/404.html",
}));

// Start the server
server.start();
console.log(
  `%c[env ${appEnv}] [type ${isLocal ? "local" : "hosted"}] [port ${appPort}] Server started`,
  "color:green",
);
