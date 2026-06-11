import chalk from "chalk";

// TODO: convert this to a class instead

// TODO: add an extra new class for interacting with ENV file, use that as the only place type-set and fallback logic is handled

export function fileExists(localFilePath: string): boolean {
  logDebug(`fileExists: ${localFilePath}`);

  try {
    const localFileCheck = Deno.lstatSync(localFilePath);
    return localFileCheck.isFile;
  } catch (_error) {
    return false;
  }
}

function log(logContent: string | string[]): void {
  // TODO: if isLocal, use `console.log` otherwise skip or something else
  console.log(logContent);
}

export function logDebug(textContent: string): void {
  log(chalk.hex("#23C5B0")(`DEBUG ${textContent}`));
}

export function logInfo(textContent: string): void {
  log(chalk.blue(textContent));
}

export function logSuccess(textContent: string): void {
  log(chalk.green(textContent));
}

export function logError(textContent: string): void {
  log(chalk.red(textContent));
}
