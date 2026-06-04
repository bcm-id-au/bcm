import { load } from "@std/dotenv";
import { format } from "@std/datetime/format";
import { serveFile } from "@std/http/file-server";

// Load variables from the ENV file

await load({
  envPath: ".site.env",
  export: true,
});

const appUrl = Deno.env.get("SITE_URL") || "http://localhost:8000";
const appPort = Number(Deno.env.get("SITE_PORT")) || 8000;
const appPublic = Deno.env.get("SITE_PUBLIC_DIR") || "public";

// Run the server on the configured port

const appUrlFull = `${appUrl}:${appPort}`;
console.log(`Server starting at ${appUrlFull}`);

Deno.serve({ port: appPort }, async (req) => {
  // Extract the request properties
  const nowDate = new Date();
  const reqDate = format(nowDate, "yyyy-MM-dd HH:mm:ss");
  const reqUrl = new URL(req.url);

  // Setup the log item prefix string
  const logPrefix = `[${reqDate}] [${req.method}] ${req.url}`;

  // Figure out the related local file path
  let localPath = "./" + appPublic + decodeURIComponent(reqUrl.pathname);

  try {
    // Check the status of the local file, files that don't exist will trigger
    // a 'Deno.errors.NotFound' error and be caught in the 'catch' block below.
    const localFileInfo = Deno.lstatSync(localPath);
    if (localFileInfo.isDirectory) {
      // Directory requests should use the 'index.html' file in that directory
      localPath = localPath.endsWith("/") ? localPath + "/index.html" : localPath + "/index.html";
    } else if (localFileInfo.isFile && localFileInfo.size === 0) {
      // Handle empty files to avoid an empty response
      console.log(`${logPrefix} ERR Empty file at ${localPath}`);
      return Response.redirect(new URL(appUrlFull, req.url));
    }

    // Attempt to serve the static file
    const response = await serveFile(req, localPath);
    console.log(`${logPrefix} ${response.status}`);

    // Handle HTTP status failure states
    if (response.status !== 200 && response.status !== 304) {
      return Response.redirect(new URL(appUrlFull, req.url));
    }

    return response;
  } catch (error) {
    // Log an appropriate error
    if (error instanceof Deno.errors.NotFound) {
      console.log(`${logPrefix} 404`);
    } else {
      console.log(`${logPrefix} ERR ${error}`);
    }

    return Response.redirect(new URL(appUrlFull, req.url));
  }
});
