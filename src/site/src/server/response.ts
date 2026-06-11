import { fileExists } from "./lookup.ts";
import { serveFile } from "@std/http/file-server";

export function responseGenerate(localFilePath: string, httpStatusCode: number): Response {
  console.log("responseGenerate", localFilePath, httpStatusCode);

  const localFileContent = Deno.readTextFileSync(localFilePath);

  return new Response(
    localFileContent,
    {
      status: httpStatusCode,
      // headers: { "content-type": "text/html; charset=utf-8" },
    },
  );
}

export function responseFromFileRequest(
  localDirPath: string,
  requestPath: unknown | string,
): Response {
  const requestStr = String(requestPath);

  console.log("responseFromFileRequest", localDirPath, requestStr);

  if (!requestStr || requestStr == "/") {
    return responseGenerate(`${localDirPath}/index.html`, 304);
  }

  const staticFilePath = `${localDirPath}/${requestStr}`;

  if (fileExists(staticFilePath)) {
    return responseGenerate(staticFilePath, 304);
  }

  const pageFilePath = `${localDirPath}/${requestStr}/index.html`;
  const pageFileExists = fileExists(pageFilePath);

  if (pageFileExists) {
    return responseGenerate(pageFilePath, 304);
  }

  const postFilePath = `${localDirPath}/posts/${requestStr}/index.html`;
  const postFileExists = fileExists(postFilePath);

  if (postFileExists) {
    return responseGenerate(postFilePath, 301);
  }

  return responseGenerate(`${localDirPath}/index.html`, 404);
}
