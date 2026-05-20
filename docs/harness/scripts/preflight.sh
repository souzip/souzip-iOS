#!/usr/bin/env bash
# Souzip harness baseline (LHE init.sh 대응)
# 실패 시 exit 1 — 새 기능 구현 전 기준선부터 복구

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT"

echo "=== Souzip preflight ==="
echo "pwd: $(pwd)"

if ! command -v tuist >/dev/null 2>&1; then
  echo "ERROR: tuist not found in PATH"
  exit 1
fi

echo "=== tuist install ==="
tuist install

echo "=== tuist generate ==="
tuist generate

echo "=== baseline OK ==="
