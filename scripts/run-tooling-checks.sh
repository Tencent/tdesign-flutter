#!/usr/bin/env bash
# GitHub selects named steps; CNB and local validation run the same full sequence.
set -euo pipefail

TOOLING_REPOSITORY_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$TOOLING_REPOSITORY_ROOT/tdesign-component"

steps=(css2token migration tool-tests runner-tests api-generator-tests api-docs snippets docs-sync structure snippet-analysis contracts)

run_step() {
  echo "Tooling check: $1"
  case "$1" in
    css2token)
      (
        cd ../packages/css2token
        dart pub get
        dart test
        dart analyze --fatal-infos
      )
      ;;
    migration) dart run tool/run_migration_consumer.dart ;;
    # Discover the directory so new tooling tests need no workflow registration.
    tool-tests) flutter test --no-pub test/tool ;;
    runner-tests) node --test "$TOOLING_REPOSITORY_ROOT/scripts/"*tooling*.test.mjs ;;
    api-generator-tests) node --test tool/*_test.mjs ;;
    api-docs) node tool/generate_api.mjs --check ;;
    snippets) dart run tool/generate_example_code.dart --check ;;
    docs-sync) node "$TOOLING_REPOSITORY_ROOT/scripts/sync-readme.mjs" --check ;;
    structure) dart run tool/check_demo_structure.dart ;;
    snippet-analysis) dart run tool/check_demo_snippets.dart ;;
    contracts) node "$TOOLING_REPOSITORY_ROOT/scripts/check-flutter-component-contracts.mjs" ;;
    *) echo "Unknown tooling step: $1" >&2; exit 64 ;;
  esac
}

if [[ $# -gt 1 ]]; then
  echo "Usage: bash scripts/run-tooling-checks.sh [step]" >&2
  exit 64
fi
if [[ $# -eq 1 ]]; then
  run_step "$1"
else
  for step in "${steps[@]}"; do
    run_step "$step"
  done
fi
