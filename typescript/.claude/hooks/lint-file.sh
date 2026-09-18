#!/usr/bin/env bash
# PostToolUse: lint + format the file Claude just wrote.
# Exit 2 shows the remaining errors to Claude so it fixes them next.
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
f=$(jq -r '.tool_input.file_path // empty')
[[ "$f" == "$PWD"/* ]] || exit 0
rc=0
case "$f" in
  *.ts | *.js) pnpm exec eslint --fix --max-warnings=0 --no-warn-ignored "$f" >&2 || rc=2 ;;
esac
pnpm exec prettier --write --ignore-unknown --log-level=warn "$f" >&2
exit $rc
