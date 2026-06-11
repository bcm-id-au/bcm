export function fileExists(localFilePath: string): boolean {
  console.log("fileExists", localFilePath);
  try {
    const localFileCheck = Deno.lstatSync(localFilePath);
    return localFileCheck.isFile;
  } catch (_error) {
    return false;
  }
}
