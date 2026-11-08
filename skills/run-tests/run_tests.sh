#!/usr/bin/env bash
# Python: lint, type-check, then tests with coverage. Prints only a summary.
set -o pipefail
ruff check . --output-format=concise 2>&1 | tail -15
mypy . --no-error-summary 2>&1 | tail -10
pytest -q --tb=short --cov --cov-report=term:skip-covered 2>&1 | tail -40
