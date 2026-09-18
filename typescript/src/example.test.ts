import { mkdtemp, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import path from "node:path";

import fc from "fast-check";
import { describe, expect, it } from "vitest";
import { ZodError } from "zod";

import { loadUser, slugify } from "./example.ts";

async function dirWithUserJson(contents: string): Promise<string> {
  const dir = await mkdtemp(path.join(tmpdir(), "app-test-"));
  await writeFile(path.join(dir, "user.json"), contents);
  return dir;
}

describe("loadUser", () => {
  it("parses a valid user", async () => {
    const dir = await dirWithUserJson(
      '{"name": "Ana", "email": "ana@example.com"}',
    );
    await expect(loadUser(dir)).resolves.toEqual({
      name: "Ana",
      email: "ana@example.com",
    });
  });

  it("rejects a user with missing fields", async () => {
    const dir = await dirWithUserJson('{"name": "Ana"}');
    await expect(loadUser(dir)).rejects.toThrow(ZodError);
  });
});

describe("slugify", () => {
  it("never contains whitespace", () => {
    fc.assert(
      fc.property(fc.string(), (text) => {
        expect(slugify(text)).not.toMatch(/\s/);
      }),
    );
  });
});
