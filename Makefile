SHELL := /usr/bin/env bash

# Disable built-in rules
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
.SUFFIXES:
.SECONDARY:

.DEFAULT_GOAL := help
.PHONY: help
help: ## Show this help
	@grep -E -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = "(: ).*?## "}; {gsub(/\\:/,":",$$1)}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: run
run: export RUNNER_TOOL_CACHE = .
run: export INPUT_VERSION = v0.1.0-rc1
run: export INPUT_ARGS = --help
run: ## Run locally
	rm -rf gsync
	@./greposync.sh
