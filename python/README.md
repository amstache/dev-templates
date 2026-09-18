# Python project template

A uv project with strict guardrails for AI-assisted coding: Ruff, pyright in strict mode, pytest with a coverage floor, and Claude Code hooks that make the agent fix lint and test failures before it can finish.

## Start a new project

```bash
cp -R ~/workspace/_playground/python ~/workspace/myproject
cd ~/workspace/myproject
```

Rename the package from `app`: the two `app` entries in `pyproject.toml`, the `src/app/` folder, and the imports in `tests/`. Then:

```bash
git init
uv sync
make check
```

Commit `uv.lock`, since CI installs with `uv sync --locked`. Delete `src/app/example.py` and its tests once you have real code.

## Commands

| Command | What it does |
|---|---|
| `make check` | Format check, lint, pyright strict, tests + coverage (85% floor) |
| `make fix` | Auto-fix lint and formatting |
| `make audit` | Known vulnerabilities in dependencies (`uv audit`, experimental) |
| `uv add <pkg>` / `uv add --dev <pkg>` | Add a dependency |

## What's enforced

- **Ruff**: bans `typing.cast`, `Any` annotations, blind `except Exception`, bare `# type: ignore` / `# noqa`, `print()`, commented-out code, naive datetimes, shell-injection patterns, and missing annotations.
- **pyright strict**: no unknown types, and `# type: ignore` comments are disabled.
- **pytest**: strict markers and config, an expected failure that passes counts as a failure, warnings are errors, 85% branch coverage, Hypothesis for property tests.
- **Claude Code hooks** (`.claude/`): after each edit, Ruff fixes and reports that file; when Claude tries to finish with uncommitted Python changes, `make check` has to pass. Needs `jq`.
- **CI** (`.github/workflows/ci.yml`): `make check` and `make audit` on every push to `main` and every PR.
- **CLAUDE.md**: the rules the tools can't enforce.

## Editor

Install the Ruff extension. For types, Pylance matches the CI checker (pyright); ty is Astral's much faster checker, still in beta.
