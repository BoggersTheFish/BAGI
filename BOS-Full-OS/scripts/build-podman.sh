#!/usr/bin/env bash
# Legacy alias — use build-ts-os.sh (TS = Thinking System).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
exec "${ROOT}/scripts/build-ts-os.sh" "$@"
