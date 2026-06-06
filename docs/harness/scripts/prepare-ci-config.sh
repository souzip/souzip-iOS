#!/usr/bin/env bash
# GitHub Actions용 Config 파일을 secrets에서 복원합니다.
# secrets가 없으면 로컬 Config/ 파일을 그대로 사용합니다.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT"

mkdir -p Config

decode_secret() {
    local name="$1"
    local target="$2"
    local value="${!name:-}"

    if [ -n "$value" ]; then
        echo "$value" | base64 --decode > "$target"
        echo "config restored from secret: $target"
        return 0
    fi

    return 1
}

restored=0

if decode_secret DEBUG_XCCONFIG Config/Debug.xcconfig; then
    restored=$((restored + 1))
fi

if decode_secret RELEASE_XCCONFIG Config/Release.xcconfig; then
    restored=$((restored + 1))
fi

if decode_secret GOOGLE_SERVICE_DEBUG Config/GoogleService-Info-Debug.plist; then
    restored=$((restored + 1))
fi

if decode_secret GOOGLE_SERVICE_RELEASE Config/GoogleService-Info-Release.plist; then
    restored=$((restored + 1))
fi

if [ "$restored" -eq 0 ]; then
    if [ -f Config/Debug.xcconfig ] && [ -f Config/Release.xcconfig ]; then
        echo "using existing Config/ files"
        exit 0
    fi

    echo "ERROR: CI build requires Config files."
    echo "Set GitHub secrets (base64-encoded):"
    echo "  SOUZIP_DEBUG_XCCONFIG"
    echo "  SOUZIP_RELEASE_XCCONFIG"
    echo "  SOUZIP_GOOGLE_SERVICE_DEBUG"
    echo "  SOUZIP_GOOGLE_SERVICE_RELEASE"
    echo
    echo "Example:"
    echo "  base64 -i Config/Debug.xcconfig | pbcopy"
    exit 1
fi

required=(
    Config/Debug.xcconfig
    Config/Release.xcconfig
    Config/GoogleService-Info-Debug.plist
    Config/GoogleService-Info-Release.plist
)

for file in "${required[@]}"; do
    if [ ! -f "$file" ]; then
        echo "ERROR: missing $file after secret restore"
        exit 1
    fi
done
