.PHONY: dev build start test check fix audit

# The [project.scripts] entry point. No install target needed: `uv run` syncs with uv.lock first.
APP := app

dev:
	uv run $(APP)

build:
	rm -rf dist
	uv build

# Runs the built wheel in a throwaway environment with only runtime dependencies,
# so it fails if app code imports a dev-only package.
start: build
	uv run --isolated --no-project --with dist/*.whl $(APP)

test:
	uv run pytest

check:
	uv run ruff format --check .
	uv run ruff check .
	uv run pyright
	uv run deptry src
	uv run pytest

fix:
	uv run ruff check --fix .
	uv run ruff format .

audit:
	uv audit --preview-features audit
