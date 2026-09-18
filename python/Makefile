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

# `--ignore-noqa` makes `# noqa` comments inert. pyright and deptry have no such switch,
# so their suppression comments are rejected outright.
check:
	uv run ruff format --check .
	uv run ruff check --ignore-noqa .
	@! grep -rnsE "#[[:space:]]*(pyright|deptry):|#[[:space:]]*pragma:[[:space:]]*no[[:space:]]*cover" src tests || { echo "Suppression comments aren't allowed: fix the code instead."; exit 1; }
	uv run pyright
	uv run deptry src
	uv run pytest

fix:
	uv run ruff check --fix --ignore-noqa .
	uv run ruff format .

audit:
	uv audit --preview-features audit
