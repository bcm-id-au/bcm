import { load } from "@std/dotenv";
import { serveDir, serveFile } from "@std/http/file-server";
import { fileExists, logDebug, logInfo } from "./server.utils.ts";

// Load variables from the Env Var file, or directly from
// the build terminal session if set there.

await load({
  envPath: ".site.env",
  export: true,
});

const publicDir: string = Deno.env.get("SITE_PUBLIC_DIR") || "public";
const appPort: number = Number(Deno.env.get("SITE_PORT")) || 8000;
const appEnv: string = Deno.env.get("SITE_ENV") || "other";
const isLocal: boolean = appEnv == "local" || false;

Deno.serve(
  {
    port: appPort,
    onListen({ port, hostname }) {
      logInfo(
        `[env ${appEnv}] [type ${
          isLocal ? "local" : "hosted"
        }] [port ${appPort}] Server started at ${hostname}:${port}`,
      );
    },
  },
  (request: Request) => {
    const requestUrl: URL = new URL(request.url);
    const requestPath: string = requestUrl.pathname;
    const req: string = requestPath.endsWith("/") ? requestPath : `${requestPath}/`;

    logDebug(`START ${request.url} > ${req}`);

    if (!req || req == "/") {
      logDebug(`root OK ${request.url} > /index.html`);

      return serveFile(
        request,
        `./${publicDir}/index.html`,
      );
    }

    const fileStatic: string = `./${publicDir}${requestPath}`;
    const filePage: string = `./${publicDir}${req}index.html`;
    const filePost: string = `./${publicDir}/posts${req}index.html`;

    if (fileExists(fileStatic)) {
      logDebug(`static OK ${request.url} > ${fileStatic}`);

      return serveFile(
        request,
        fileStatic,
      );
    }

    if (fileExists(filePage)) {
      logDebug(`page OK ${request.url} > ${filePage}`);

      return serveFile(
        request,
        filePage,
      );
    }

    if (fileExists(filePost)) {
      logDebug(`post OK ${request.url} > ${filePost}`);

      return serveFile(
        request,
        filePost,
      );
    }

    if (!fileExists(fileStatic)) {
      logDebug(`static 404 ERR ${request.url} > ${fileStatic}`);

      const homePage = new URL("/", requestUrl.origin);

      return Response.redirect(homePage, 301);
    }

    logDebug(`dir serve INFO ${request.url} > serve dir`);

    return serveDir(request, {
      fsRoot: `./${publicDir}`,
    });
  },
);
