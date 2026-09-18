.PHONY: dev build start test check fix audit

# Reinstall when dependencies change, like `uv run` does in the Python template.
node_modules: package.json $(wildcard pnpm-lock.yaml)
	pnpm install
	@touch node_modules

dev: node_modules
	pnpm dev

build: node_modules
	pnpm build

start: build
	pnpm start

test: node_modules
	pnpm test

check: node_modules
	pnpm check

fix: node_modules
	pnpm fix

audit:
	pnpm audit
