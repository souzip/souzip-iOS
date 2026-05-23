#!/usr/bin/env bash
# Souzip harness baseline (LHE init.sh 대응)
# 실패 시 exit 1 — 새 기능 구현 전 기준선부터 복구

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT"

echo "=== Souzip preflight ==="
echo "pwd: $(pwd)"

if command -v tuist >/dev/null 2>&1; then
  TUIST_CMD=(tuist)
elif command -v mise >/dev/null 2>&1; then
  TUIST_CMD=(mise exec -- tuist)
elif [ -x "$HOME/.local/bin/mise" ]; then
  TUIST_CMD=("$HOME/.local/bin/mise" exec -- tuist)
else
  echo "ERROR: tuist not found in PATH and mise is unavailable"
  exit 1
fi

echo "tuist: ${TUIST_CMD[*]}"

echo "=== tuist install ==="
"${TUIST_CMD[@]}" install

echo "=== tuist generate ==="
"${TUIST_CMD[@]}" generate

echo "=== baseline OK ==="
