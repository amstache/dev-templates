# Python project template

A uv project with strict guardrails for AI-assisted coding: Ruff, pyright in strict mode, pytest with a coverage floor, and Claude Code hooks that make the agent fix lint and test failures before it can finish.

## Start a new project

```bash
cp -R ~/workspace/_playground/python ~/workspace/myproject
cd ~/workspace/myproject
```

Rename the package from `app`: the two `app` entries in `pyproject.toml`, `APP` in the `Makefile`, the `src/app/` folder, and the imports in `tests/`. Then:

```bash
git init
make check
```

Commit `uv.lock`, since CI installs with `uv sync --locked`. Delete `src/app/example.py` and its tests once you have real code.

## Commands

| Command | What it does |
|---|---|
| `make dev` | Run the app from source |
| `make build` | Build the wheel and sdist into `dist/` |
| `make start` | Build, then run the wheel in a clean environment with only runtime dependencies |
| `make check` | Format check, lint, pyright strict, dependency check, tests + coverage (85% floor) |
| `make fix` | Auto-fix lint and formatting |
| `make test` | Tests + coverage only |
| `make audit` | Known vulnerabilities in dependencies (`uv audit`, experimental) |
| `uv add <pkg>` / `uv add --dev <pkg>` | Add a dependency |

These are the same `make` commands as the TypeScript template. There's no install step: `uv run` syncs the environment first. `make start` runs what you'd actually ship (the built wheel, with only runtime dependencies), so it also confirms the package builds and its entry point works.

## What's enforced

- **Ruff**: bans `typing.cast` and `typing.Any` (also inside `dict[str, Any]`), blind `except Exception`, `print()`, commented-out code, naive datetimes, shell-injection patterns, and missing annotations. `make check` runs it with `--ignore-noqa`, so `# noqa` comments don't silence anything; a genuine exception goes in `per-file-ignores`, where it's visible.
- **pyright strict**: no unknown types. `# type: ignore` comments are disabled, and `make check` rejects `# pyright:` comments, which could otherwise silence an error or take a whole file out of strict mode.
- **deptry**: every import in `src/` must come from a declared dependency of the right kind. It flags dev-only packages used by app code (they work locally but break in production installs), packages that are only installed because another dependency needs them, undeclared imports, and packages under `dependencies` that only tests use. `# deptry:` comments are rejected too.
- **pytest**: strict markers and config, an expected failure that passes counts as a failure, warnings are errors, 85% branch coverage, Hypothesis for property tests. `make check` rejects `# pragma: no cover`, which would hide untested code from the coverage floor. Ruff bans skipping tests or marking them as expected failures in any form: `pytest.mark.skip` / `skipif` / `xfail`, `pytest.skip()`, `pytest.xfail()`, `pytest.importorskip()`, and the `unittest` equivalents. Every test must assert something (checked by the root `conftest.py`): an `assert`, `pytest.raises` / `pytest.warns`, or an `assert*` call such as a mock's `assert_called_once()` or your own `assert_*` helper.
- **Claude Code hooks** (`.claude/`): after each edit, Ruff fixes and reports that file; when Claude tries to finish with uncommitted Python changes, `make check` has to pass. If Claude changed the files that define the checks (the `[tool.*]` settings in `pyproject.toml`, the `Makefile`, the root `conftest.py`, CI, or `.claude/`), it's stopped once and told to revert the change or explain it to you; you approve by committing. Needs `jq`.
- **CI** (`.github/workflows/ci.yml`): `make check` and `make audit` on every push to `main` and every PR.
- **CLAUDE.md**: the rules the tools can't enforce.

## Editor

Install the Ruff extension. For types, Pylance matches the CI checker (pyright); ty is Astral's much faster checker, still in beta.
