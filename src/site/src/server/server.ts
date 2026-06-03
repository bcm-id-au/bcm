import { load } from "@std/dotenv";
import { format } from "@std/datetime/format";
import { serveDir } from "@std/http/file-server";

// Load variables from the ENV file

await load({
  envPath: ".site.env",
  export: true,
});

const appUrl = Deno.env.get("SITE_URL") || "http://localhost:8000";
const appPort = Number(Deno.env.get("SITE_PORT")) || 8000;
const appPublic = Deno.env.get("SITE_PUBLIC_DIR") || "public";

Deno.serve({ port: appPort }, async (req) => {
  // Extract the request properties
  const nowDate = new Date();
  const reqDate = format(nowDate, "yyyy-MM-dd HH:mm:ss");
  const reqPath = new URL(req.url).pathname;
  const logPrefix = `[${reqDate}] [${req.method}] ${reqPath}`;

  try {
    // Get information about the related file/directory
    const fsInfo = Deno.lstatSync(`./${appPublic}${reqPath}`);
    if (fsInfo.isFile && fsInfo.size === 0) {
      console.log(`${logPrefix} ERROR empty file`);

      return Response.redirect(new URL(appUrl, req.url));
    }

    // Attempt to serve the static file
    const response = await serveDir(req, {
      fsRoot: "./" + appPublic,
      showDirListing: false,
      showDotfiles: false,
      showIndex: true,
    });

    // Handle HTTP status failure states
    if (response.status !== 200 && response.status !== 304) {
      console.log(`${logPrefix} ${response.status}`);

      return Response.redirect(new URL(appUrl, req.url));
    }

    return response;
  } catch (error) {
    // Log an appropriate error
    if (error instanceof Deno.errors.NotFound) {
      console.log(`${logPrefix} 404`);
    } else {
      console.log(`${logPrefix} ERROR ${error}`);
    }

    return Response.redirect(new URL(appUrl, req.url));
  }
});
