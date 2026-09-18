// Example code showing the project's conventions. Delete once you have real code.
import { readFile } from "node:fs/promises";
import path from "node:path";

import * as z from "zod";

export const User = z.object({
  name: z.string(),
  email: z.email(),
});
export type User = z.infer<typeof User>;

// Validate external data at the boundary instead of trusting `JSON.parse` or `as User`.
export async function loadUser(directory: string): Promise<User> {
  const text = await readFile(path.join(directory, "user.json"), "utf8");
  return User.parse(JSON.parse(text));
}

export function slugify(text: string): string {
  return text.toLowerCase().split(/\s+/).filter(Boolean).join("-");
}
