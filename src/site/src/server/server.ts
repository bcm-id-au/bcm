import { load } from "@std/dotenv";
import { serveDir } from "@std/http/file-server";

// Load variables from the ENV file

await load({
  envPath: ".site.env",
  export: true,
});

// TODO: serve: ../public
// TODO: listen on port: 8000
// TODO: previous command: deno run --allow-net --allow-read jsr:@std/http/file-server ./public --port 8000

const appUrl = Deno.env.get("SITE_URL") || "http://localhost:8000";
const appPort = Number(Deno.env.get("SITE_PORT")) || 8000;
const appPublic = Deno.env.get("SITE_PUBLIC_DIR") || "public";

Deno.serve({ port: appPort }, async (req) => {
  try {
    const response = await serveDir(req, {
      fsRoot: "./" + appPublic,
      showDirListing: false,
      showDotfiles: false,
      showIndex: true,
    });

    if (response.status === 404) {
      return Response.redirect(new URL(appUrl, req.url));
    }

    return response;
  } catch (error) {
    console.log(`[${req.method}] ${req.url} ERROR ${error}`);
    return Response.redirect(new URL(appUrl, req.url));
  }
});
