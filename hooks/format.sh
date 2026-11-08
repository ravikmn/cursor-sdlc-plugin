#!/usr/bin/env bash
# Format Python files after each edit. Never blocks the edit.
ruff format --quiet . && ruff check --fix --quiet . || true
echo '{}'
