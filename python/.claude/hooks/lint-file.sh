#!/usr/bin/env bash
# PostToolUse: lint + format the Python file Claude just wrote.
# Exit 2 shows the remaining errors to Claude so it fixes them next.
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
f=$(jq -r '.tool_input.file_path // empty')
[[ "$f" == *.py ]] || exit 0
uv run --quiet ruff check --fix --ignore-noqa --output-format concise "$f" >&2; rc=$?
uv run --quiet ruff format --quiet "$f"
[[ $rc -eq 0 ]] || exit 2
