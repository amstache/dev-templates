import js from "@eslint/js";
import vitest from "@vitest/eslint-plugin";
import { defineConfig, globalIgnores } from "eslint/config";
import prettier from "eslint-config-prettier";
import simpleImportSort from "eslint-plugin-simple-import-sort";
import tseslint from "typescript-eslint";

export default defineConfig(
  globalIgnores(["dist/", "coverage/"]),
  js.configs.recommended,
  {
    // `eslint-disable` comments do nothing: exceptions go in this file, where they're visible.
    linterOptions: { noInlineConfig: true },
    plugins: { "simple-import-sort": simpleImportSort },
    rules: {
      "simple-import-sort/imports": "error",
      "simple-import-sort/exports": "error",
      // Coverage-ignore comments hide untested code, and knip skips exports tagged public or beta.
      "no-warning-comments": [
        "error",
        {
          terms: [
            "v8 ignore",
            "c8 ignore",
            "istanbul ignore",
            "@public",
            "@beta",
          ],
          location: "anywhere",
        },
      ],
      "no-console": "error",
      eqeqeq: "error",
      complexity: ["error", 10],
    },
  },
  {
    files: ["**/*.ts"],
    extends: [
      tseslint.configs.strictTypeChecked,
      tseslint.configs.stylisticTypeChecked,
    ],
    languageOptions: {
      parserOptions: {
        projectService: true,
        tsconfigRootDir: import.meta.dirname,
      },
    },
    rules: {
      // No `as` casts (except `as const`): validate or narrow instead.
      "@typescript-eslint/consistent-type-assertions": [
        "error",
        { assertionStyle: "never" },
      ],
      // No @ts-ignore, @ts-expect-error or @ts-nocheck, even with a description.
      "@typescript-eslint/ban-ts-comment": [
        "error",
        { "ts-expect-error": true, "ts-ignore": true, "ts-nocheck": true },
      ],
      "@typescript-eslint/switch-exhaustiveness-check": "error",
      "@typescript-eslint/explicit-module-boundary-types": "error",
      "@typescript-eslint/consistent-type-imports": "error",
    },
  },
  {
    files: ["**/*.test.ts"],
    extends: [vitest.configs.recommended],
    rules: {
      "vitest/no-disabled-tests": "error",
      "vitest/no-focused-tests": "error",
    },
  },
  prettier,
);
