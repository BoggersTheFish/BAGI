#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REDOX_DIR="${ROOT}/redox"
if [[ -d "${REDOX_DIR}/.git" ]]; then
  echo "redox/ already exists; pulling..."
  git -C "${REDOX_DIR}" pull --ff-only || true
else
  echo "Cloning Redox into ${REDOX_DIR} ..."
  git clone https://gitlab.redox-os.org/redox-os/redox.git "${REDOX_DIR}"
fi
echo "Done. Next: ./scripts/apply-overlay.sh && follow README build steps."
