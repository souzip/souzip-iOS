#!/usr/bin/env bash
# Souzip harness verification.
# Usage:
#   docs/harness/scripts/verify.sh plan
#   VERIFY_TEST_TARGETS="DomainTests" docs/harness/scripts/verify.sh plan
#   docs/harness/scripts/verify.sh story

set -euo pipefail

MODE="${1:-plan}"
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT"

BUILD_SCHEME="${VERIFY_BUILD_SCHEME:-수집-Debug}"
TEST_SCHEME="${VERIFY_TEST_SCHEME:-}"
TEST_TARGETS="${VERIFY_TEST_TARGETS:-}"

run_tool() {
    local tool="$1"
    shift

    if command -v "$tool" >/dev/null 2>&1; then
        "$tool" "$@"
    elif command -v mise >/dev/null 2>&1; then
        mise exec -- "$tool" "$@"
    elif [ -x "$HOME/.local/bin/mise" ]; then
        "$HOME/.local/bin/mise" exec -- "$tool" "$@"
    else
        echo "ERROR: $tool not found and mise is unavailable"
        exit 1
    fi
}

run_test() {
    if [ -n "$TEST_TARGETS" ]; then
        if [ -n "$TEST_SCHEME" ]; then
            run_tool tuist test "$TEST_SCHEME" --test-targets "$TEST_TARGETS" --skip-ui-tests --no-upload
        else
            run_tool tuist test --test-targets "$TEST_TARGETS" --skip-ui-tests --no-upload
        fi
    elif [ -n "$TEST_SCHEME" ]; then
        run_tool tuist test "$TEST_SCHEME" --skip-ui-tests --no-upload
    elif [ "$MODE" = "story" ] || [ "$MODE" = "pr" ]; then
        run_tool tuist test --skip-ui-tests --no-upload
    else
        echo "SKIP: related tests not specified. Set VERIFY_TEST_TARGETS or VERIFY_TEST_SCHEME, or record the skip reason in the Plan."
    fi
}

case "$MODE" in
    plan|story|pr)
        ;;
    *)
        echo "ERROR: unknown mode '$MODE' (expected: plan, story, pr)"
        exit 1
        ;;
esac

echo "=== Souzip verify: $MODE ==="

echo "=== SwiftFormat lint ==="
run_tool swiftformat . --config .swiftformat --lint

echo "=== SwiftLint ==="
run_tool swiftlint lint --config .swiftlint.yml

echo "=== Tuist generate ==="
run_tool tuist generate

echo "=== Tuist build: $BUILD_SCHEME ==="
run_tool tuist build "$BUILD_SCHEME"

echo "=== Tuist tests ==="
run_test

echo "=== verify OK: $MODE ==="
