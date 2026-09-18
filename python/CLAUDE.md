# CLAUDE.md

Python project managed with uv. Code in `src/app/`, tests in `tests/` (pytest).

## Commands

- `make check`: format check, Ruff, pyright strict, deptry, pytest + coverage. Must pass before you say you're done.
- `make fix`: auto-fix lint and formatting.
- `uv add <pkg>` / `uv add --dev <pkg>`: never `pip install`. Ask before adding a dependency.

## Rules

- Never loosen tooling to make errors go away; fix the code. Suppression comments won't help: `make check` ignores `# noqa` and rejects `# pyright:`, `# deptry:` and `# pragma: no cover` comments. Changing the files that define the checks (the `[tool.*]` settings in `pyproject.toml`, the `Makefile`, the root `conftest.py`, CI, `.claude/`) needs the user's approval, so ask first.
- Validate external data (files, HTTP responses, env vars, JSON) with Pydantic models at the boundary; don't pass raw dicts around.
- When implementing against existing tests, don't change the tests.
- Keep changes scoped to the task; no drive-by refactors.
