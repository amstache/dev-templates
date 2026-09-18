import { expect, it, vi } from "vitest";

import { run } from "./app.ts";

it("prints the slug", () => {
  const write = vi.spyOn(process.stdout, "write").mockReturnValue(true);
  run();
  expect(write).toHaveBeenCalledWith("hello-world\n");
});
