#!/usr/bin/env bash
# Prepare a fresh Souzip Story worktree.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
LOCAL_CONFIG_DIR="${SOUZIP_CONFIG_DIR:-$HOME/.souzip/config}"

cd "$ROOT"

echo "=== Souzip worktree bootstrap ==="
echo "pwd: $(pwd)"
echo "config source: $LOCAL_CONFIG_DIR"

mkdir -p Config

missing_configs=()
required_configs=(
  "Debug.xcconfig"
  "Release.xcconfig"
)

for config in "${required_configs[@]}"; do
  target="Config/$config"
  source="$LOCAL_CONFIG_DIR/$config"

  if [ -f "$target" ]; then
    echo "config exists: $target"
  elif [ -f "$source" ]; then
    cp "$source" "$target"
    echo "config copied: $source -> $target"
  else
    missing_configs+=("$config")
  fi
done

if [ "${#missing_configs[@]}" -gt 0 ]; then
  echo "ERROR: missing local config files:"
  for config in "${missing_configs[@]}"; do
    echo "  - $LOCAL_CONFIG_DIR/$config"
  done
  echo
  echo "Create them from Config/Example.xcconfig, then rerun this script."
  echo "You can override the source directory with SOUZIP_CONFIG_DIR=/path/to/config."
  exit 1
fi

docs/harness/scripts/preflight.sh
