#!/usr/bin/env bash
# Souzip harness verification.
# Usage:
#   docs/harness/scripts/verify.sh plan
#   VERIFY_TEST_SCHEME="Domain" docs/harness/scripts/verify.sh plan
#   docs/harness/scripts/verify.sh story

set -euo pipefail

MODE="${1:-plan}"
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT"

BUILD_SCHEME="${VERIFY_BUILD_SCHEME:-수집-Debug}"
TEST_SCHEME="${VERIFY_TEST_SCHEME:-}"
TEST_TARGETS="${VERIFY_TEST_TARGETS:-}"
TEST_DESTINATION="${VERIFY_TEST_DESTINATION:-}"

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

module_project_for_scheme() {
    local scheme="$1"
    local candidates=(
        "Projects/$scheme/$scheme.xcodeproj"
        "Projects/Core/$scheme/$scheme.xcodeproj"
        "Projects/Shared/$scheme/$scheme.xcodeproj"
    )

    local candidate
    for candidate in "${candidates[@]}"; do
        if [ -d "$candidate" ]; then
            echo "$candidate"
            return 0
        fi
    done

    return 1
}

default_test_destination() {
    local device_id
    device_id="$(xcrun simctl list devices available 2>/dev/null | sed -nE 's/.*\(([0-9A-F-]{36})\) \((Booted|Shutdown)\).*/\1/p' | head -n 1)"

    if [ -n "$device_id" ]; then
        echo "platform=iOS Simulator,id=$device_id"
    else
        echo "generic/platform=iOS Simulator"
    fi
}

run_xcodebuild_test() {
    local project="$1"
    local scheme="$2"
    local destination="${TEST_DESTINATION:-$(default_test_destination)}"
    local args=(
        test
        -project "$project"
        -scheme "$scheme"
        -destination "$destination"
    )

    if [ -n "$TEST_TARGETS" ]; then
        local target
        for target in ${TEST_TARGETS//,/ }; do
            args+=("-only-testing:$target")
        done
    fi

    xcodebuild "${args[@]}"
}

run_tuist_test() {
    if [ -n "$TEST_TARGETS" ]; then
        if [ -n "$TEST_SCHEME" ]; then
            run_tool tuist test "$TEST_SCHEME" --test-targets "$TEST_TARGETS" --skip-ui-tests --no-upload
        else
            run_tool tuist test --test-targets "$TEST_TARGETS" --skip-ui-tests --no-upload
        fi
    elif [ -n "$TEST_SCHEME" ]; then
        run_tool tuist test "$TEST_SCHEME" --skip-ui-tests --no-upload
    else
        run_tool tuist test --skip-ui-tests --no-upload
    fi
}

run_test() {
    if [ -n "$TEST_SCHEME" ]; then
        local project
        if project="$(module_project_for_scheme "$TEST_SCHEME")"; then
            echo "Using xcodebuild test for module scheme '$TEST_SCHEME'"
            echo "Project: $project"
            echo "Destination: ${TEST_DESTINATION:-$(default_test_destination)}"
            run_xcodebuild_test "$project" "$TEST_SCHEME"
        else
            run_tuist_test
        fi
    elif [ "$MODE" = "story" ] || [ "$MODE" = "pr" ]; then
        run_tuist_test
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

echo "=== SwiftLint (strict) ==="
docs/harness/scripts/swiftlint-strict.sh

echo "=== Tuist generate ==="
run_tool tuist generate

echo "=== Tuist build: $BUILD_SCHEME ==="
run_tool tuist build "$BUILD_SCHEME"

echo "=== Tuist tests ==="
run_test

echo "=== verify OK: $MODE ==="
