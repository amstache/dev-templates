# TypeScript project template

A Node 24 + pnpm project with strict guardrails for AI-assisted coding: TypeScript's strictest settings, type-aware ESLint, Vitest with a coverage floor, knip for dead code, and Claude Code hooks that make the agent fix lint and test failures before it can finish.

## Start a new project

```bash
cp -R ~/workspace/_playground/typescript ~/workspace/myproject
cd ~/workspace/myproject
```

Rename `app` in `package.json`, then:

```bash
git init
make check
```

Commit `pnpm-lock.yaml`, since CI installs with `--frozen-lockfile`. Delete `src/example.ts` and its test once you have real code.

## Commands

| Command           | What it does                                                       |
| ----------------- | ------------------------------------------------------------------ |
| `make dev`        | Run `src/main.ts` with Node, restarting on changes                 |
| `make build`      | Compile to `dist/`                                                 |
| `make start`      | Build, then run `dist/main.js`                                     |
| `make check`      | Format check, lint, type check, knip, tests + coverage (85% floor) |
| `make fix`        | Auto-fix lint and formatting                                       |
| `make test`       | Tests + coverage only                                              |
| `make audit`      | Known vulnerabilities in dependencies                              |
| `pnpm test:watch` | Vitest in watch mode                                               |

Each `make` target calls the pnpm script of the same name, the same commands as the Python template. It runs `pnpm install` first whenever `package.json` or the lockfile changed.

## What's enforced

- **TypeScript**: `strict` plus `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `noPropertyAccessFromIndexSignature` and friends. `erasableSyntaxOnly` keeps the code runnable by Node directly.
- **ESLint** (`strictTypeChecked`): bans `any` and unsafe use of it, `as` casts (except `as const`), non-null `!`, `@ts-ignore`, floating promises, non-exhaustive `switch`es on unions, exported functions without declared types, `console`, `==`, and `eslint-disable` comments without a reason or that no longer suppress anything. In tests: no `.skip` / `.only`, and every test must assert something.
- **Vitest**: 85% coverage on lines, branches, functions and statements; mocks are restored after each test; fast-check for property tests.
- **knip**: unused files, exports and dependencies, and imports of packages missing from `package.json`. A second, production-only pass catches app code importing a devDependency (it works locally but breaks in production installs) and packages under `dependencies` that only tests use.
- **pnpm**: `minimumReleaseAge` refuses package versions published less than 7 days ago, which gives compromised releases time to be caught.
- **Claude Code hooks** (`.claude/`): after each edit, ESLint and Prettier fix and report that file; when Claude tries to finish with uncommitted code changes, `make check` has to pass. Needs `jq`.
- **CI** (`.github/workflows/ci.yml`): `make check` and `make audit` on every push to `main` and every PR.
- **CLAUDE.md**: the rules the tools can't enforce.

## Using it with a framework

For Next.js, Astro and the like, scaffold with the framework's own CLI, then bring over the guardrails: the strict flags from `tsconfig.json`, `eslint.config.js`, the Vitest thresholds, `knip`, `pnpm-workspace.yaml`, `.claude/` and `CLAUDE.md`.

## TypeScript 7

TypeScript is pinned to `~6.0.3` because typescript-eslint doesn't support TypeScript 7 yet (its peer range is `<6.1.0`). Move to 7 once it does.
