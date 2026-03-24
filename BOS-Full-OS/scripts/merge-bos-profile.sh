#!/usr/bin/env bash
# Phase 1: merge BOS-Full-OS [packages] into the Redox desktop profile (idempotent).
# Set REDOX_PROFILE to override path. TS = Thinking System (not TypeScript).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REDOX="${ROOT}/redox"
PY="${ROOT}/scripts/merge_bos_into_redox_profile.py"

if [[ ! -d "${REDOX}/.git" ]] && [[ ! -d "${REDOX}" ]]; then
  echo "redox/ not found — skip profile merge (clone Redox first)."
  exit 0
fi

resolve_profile() {
  if [[ -n "${REDOX_PROFILE:-}" ]]; then
    echo "${REDOX_PROFILE}"
    return
  fi
  local cands=(
    "${REDOX}/config/x86_64/desktop.toml"
    "${REDOX}/config/x86_64/demo.toml"
    "${REDOX}/config/desktop.toml"
  )
  local p
  for p in "${cands[@]}"; do
    if [[ -f "$p" ]]; then
      echo "$p"
      return
    fi
  done
  echo ""
}

PROFILE="$(resolve_profile)"
if [[ -z "${PROFILE}" ]]; then
  echo "No Redox profile found (tried x86_64/desktop.toml, demo.toml, desktop.toml). Skip merge."
  echo "Set REDOX_PROFILE=/path/to/your/profile.toml to merge manually."
  exit 0
fi

if ! command -v python3 >/dev/null 2>&1 && ! command -v python >/dev/null 2>&1; then
  echo "python3 not found — cannot merge profile. Install Python 3.11+ or merge config.toml by hand."
  exit 1
fi

PYTHON=python3
command -v python3 >/dev/null 2>&1 || PYTHON=python

"${PYTHON}" "${PY}" "${PROFILE}"
