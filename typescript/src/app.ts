import { slugify } from "./example.ts";

export function run(): void {
  process.stdout.write(`${slugify("Hello World")}\n`);
}
