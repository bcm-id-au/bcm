import { serveDir, serveFile } from "@std/http/file-server";
import { Site } from "$be/site.class.ts";

// Load Env Vars with suitable defaults

const bcm = new Site("./.site.env");

const publicDir: string = bcm.envVar("SITE_PUBLIC_DIR", "public");
const appPort: number = bcm.envVarNumber("SITE_PORT", 8000);
const appEnv: string = bcm.envVar("SITE_ENV", "other");
const isLocal: boolean = bcm.isLocal();
const appEnvType: string = isLocal ? "local" : "hosted";
const appHostname: string = bcm.envVar("SITE_DOCKER_HOSTNAME", "0.0.0.0");

// Start the static web server

Deno.serve(
  {
    port: appPort,
    hostname: appHostname,
    onListen() {
      bcm.logAlways(
        `[env ${appEnv}] [type ${appEnvType}] [port ${appPort}] Server started at ${appHostname}:${appPort}`,
      );
    },
  },
  (request: Request) => {
    const requestUrl: URL = new URL(request.url);
    const requestPath: string = requestUrl.pathname;
    const req: string = requestPath.endsWith("/") ? requestPath : `${requestPath}/`;

    if (!req || req == "/") {
      return serveFile(
        request,
        `./${publicDir}/index.html`,
      );
    }

    const fileStatic: string = `./${publicDir}${requestPath}`;
    const filePage: string = `./${publicDir}${req}index.html`;
    const filePost: string = `./${publicDir}/posts${req}index.html`;

    if (bcm.fileExists(fileStatic)) {
      return serveFile(
        request,
        fileStatic,
      );
    }

    if (bcm.fileExists(filePage)) {
      return serveFile(
        request,
        filePage,
      );
    }

    if (bcm.fileExists(filePost)) {
      return serveFile(
        request,
        filePost,
      );
    }

    if (!bcm.fileExists(fileStatic)) {
      const homePage = new URL("/", requestUrl.origin);
      return Response.redirect(homePage, 301);
    }

    return serveDir(request, {
      fsRoot: `./${publicDir}`,
    });
  },
);
