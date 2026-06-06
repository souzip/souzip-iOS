#!/usr/bin/env bash
# SwiftLint를 strict 모드로 실행합니다. warning/error 모두 실패합니다.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT"

run_swiftlint() {
    if command -v swiftlint >/dev/null 2>&1; then
        swiftlint "$@"
    elif command -v mise >/dev/null 2>&1; then
        mise exec -- swiftlint "$@"
    elif [ -x "$HOME/.local/bin/mise" ]; then
        "$HOME/.local/bin/mise" exec -- swiftlint "$@"
    else
        echo "ERROR: swiftlint not found and mise is unavailable"
        exit 1
    fi
}

run_swiftlint lint --config .swiftlint.yml --strict
