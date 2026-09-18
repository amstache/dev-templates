# CLAUDE.md

TypeScript on Node 24, managed with pnpm. Code and co-located tests (`*.test.ts`) live in `src/`. Node runs `.ts` files directly, so import local files with the `.ts` extension.

## Commands

- `pnpm check`: format check, ESLint, tsc, knip, Vitest + coverage. Must pass before you say you're done.
- `pnpm fix`: auto-fix lint and formatting.
- `pnpm add <pkg>` / `pnpm add -D <pkg>`. Ask before adding a dependency.

## Rules

- Never loosen tooling to make errors go away: no `eslint-disable` or `@ts-expect-error` comments, no edits to the ESLint, TypeScript, or Vitest config, no lower coverage thresholds. Fix the code. If a suppression is truly unavoidable, ask first.
- Validate external data (HTTP responses, files, env vars, `JSON.parse`) with Zod schemas at the boundary, and derive types from them with `z.infer`.
- When implementing against existing tests, don't change the tests.
- Keep changes scoped to the task; no drive-by refactors.
