.PHONY: check fix audit

check:
	uv run ruff format --check .
	uv run ruff check .
	uv run pyright
	uv run pytest

fix:
	uv run ruff check --fix .
	uv run ruff format .

audit:
	uv audit --preview-features audit
