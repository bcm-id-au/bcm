import { loadSync } from "@std/dotenv";
import chalk from "chalk";

export class Site {
  private envFile: string;
  private env: Record<string, string> | undefined;

  constructor(envFile: string) {
    this.envFile = envFile;

    if (this.fileExists(envFile)) {
      this.logAlways("Loading variables from Env File");

      // Load variables from ths file, or directly from
      // the build terminal session if they're set there.
      this.env = loadSync({
        envPath: envFile,
        export: true,
      });
    } else {
      this.logAlways("Loading variables from Session");
    }
  }

  public envVar(varName: string, defaultValue?: string): string {
    return Deno.env.get(varName) || defaultValue || "";
  }

  public envVarNumber(varName: string, defaultValue?: number): number {
    return Number(Deno.env.get(varName)) || defaultValue || 0;
  }

  public isLocal(): boolean {
    return this.envVar("SITE_ENV") == "local";
  }

  public fileExists(localFilePath: string): boolean {
    try {
      const localFileCheck = Deno.lstatSync(localFilePath);
      return localFileCheck.isFile;
    } catch (_error) {
      return false;
    }
  }

  private log(logContent: string | string[]): void {
    if (this.isLocal()) {
      console.log(logContent);
    }
  }

  public logAlways(textContent: string): void {
    console.log(chalk.hex("#D2A6FF")(`${textContent}`));
  }

  public logDebug(textContent: string): void {
    this.log(chalk.hex("#23C5B0")(`DEBUG ${textContent}`));
  }

  public logInfo(textContent: string): void {
    this.log(chalk.blue(textContent));
  }

  public logSuccess(textContent: string): void {
    this.log(chalk.green(textContent));
  }

  public logError(textContent: string): void {
    this.log(chalk.red(textContent));
  }
}
