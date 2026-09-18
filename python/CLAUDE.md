# CLAUDE.md

Python project managed with uv. Code in `src/app/`, tests in `tests/` (pytest).

## Commands

- `make check`: format check, Ruff, pyright strict, deptry, pytest + coverage. Must pass before you say you're done.
- `make fix`: auto-fix lint and formatting.
- `uv add <pkg>` / `uv add --dev <pkg>`: never `pip install`. Ask before adding a dependency.

## Rules

- Never loosen tooling to make errors go away: no new Ruff or deptry ignores, `# noqa`, `# pyright: ignore`, `# deptry: ignore`, `cast()`, `Any`, or lower coverage threshold. Fix the code. If a suppression is truly unavoidable, ask first.
- Validate external data (files, HTTP responses, env vars, JSON) with Pydantic models at the boundary; don't pass raw dicts around.
- When implementing against existing tests, don't change the tests. Never add `skip`/`xfail` to get green.
- Keep changes scoped to the task; no drive-by refactors.
