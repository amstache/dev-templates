# CLAUDE.md

TypeScript on Node 24, managed with pnpm. Code and co-located tests (`*.test.ts`) live in `src/`. Node runs `.ts` files directly, so import local files with the `.ts` extension.

## Commands

- `make check`: format check, ESLint, tsc, knip, Vitest + coverage. Must pass before you say you're done.
- `make fix`: auto-fix lint and formatting.
- `pnpm add <pkg>` / `pnpm add -D <pkg>`. Ask before adding a dependency.

## Rules

- Never loosen tooling to make errors go away; fix the code. Suppression comments won't help: `eslint-disable` comments are switched off, and `@ts-` directives and coverage-ignore comments are lint errors. Changing the files that define the checks (ESLint, TypeScript, Vitest, Prettier or knip config, `package.json` scripts, the `Makefile`, CI, `.claude/`) needs the user's approval, so ask first.
- Validate external data (HTTP responses, files, env vars, `JSON.parse`) with Zod schemas at the boundary, and derive types from them with `z.infer`.
- When implementing against existing tests, don't change the tests.
- Keep changes scoped to the task; no drive-by refactors.
