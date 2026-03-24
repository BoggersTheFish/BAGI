#!/usr/bin/env bash
# TS-OS one-command build: clone Redox → overlay → kernel inject → idle hook → Podman → QEMU hint.
# TS = Thinking System / Thinking Wave (not TypeScript).
# Run from BOS-Full-OS:  ./scripts/build-ts-os.sh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT}"

echo "=== BOS-Full-OS / TS-OS build-ts-os.sh ==="
echo "Phase 1: profile merge runs unless SKIP_PROFILE_MERGE=1"

echo "=== [1/7] clone Redox (if missing) ==="
if [[ ! -d "${ROOT}/redox/.git" ]]; then
  "${ROOT}/scripts/clone-redox.sh"
else
  echo "redox/ present, skipping clone."
fi

echo "=== [2/7] cookbook overlay ==="
"${ROOT}/scripts/apply-overlay.sh"

echo "=== [3/7] merge BOS packages into Redox profile (Phase 1) ==="
if [[ "${SKIP_PROFILE_MERGE:-}" == "1" ]]; then
  echo "SKIP_PROFILE_MERGE=1 — not merging config.toml into redox profile."
else
  "${ROOT}/scripts/merge-bos-profile.sh" || {
    echo "WARNING: merge-bos-profile.sh failed — merge config.toml [packages] by hand or set SKIP_PROFILE_MERGE=1"
  }
fi

echo "=== [4/7] kernel TS integration ==="
"${ROOT}/scripts/apply-kernel-integration.sh"

echo "=== [5/7] idle hook ==="
if ! "${ROOT}/scripts/apply-idle-hook.sh"; then
  echo "WARNING: apply-idle-hook.sh failed — see patches/INJECT-POINTS.md"
fi

echo "=== [6/7] Podman build (run from redox/) ==="
cd "${ROOT}/redox"
if [[ -f ./podman_build.sh ]]; then
  ./podman_build.sh "$@"
elif [[ -f ./podman-bootstrap.sh ]]; then
  ./podman-bootstrap.sh "$@"
else
  echo "No podman_build.sh — https://doc.redox-os.org/book/building-the-redox-os.html"
  exit 1
fi

echo ""
echo "=== [7/7] ISO + QEMU ==="
cd "${ROOT}/redox"
ISO="$(find . -type f \( -name '*.iso' -o -name 'live.iso' -o -name 'redox.iso' \) 2>/dev/null | head -1 || true)"
if [[ -n "${ISO}" ]]; then
  echo "ISO: ${ROOT}/redox/${ISO}"
  echo ""
  echo "QEMU (host path):"
  echo "  qemu-system-x86_64 -m 2048 -cdrom \"${ROOT}/redox/${ISO}\""
  echo ""
  echo "WSL: cd to redox and use the same -cdrom with /mnt/... path, or: make run"
else
  echo "No .iso found yet — check redox/build/ per upstream."
fi

if [[ "${SKIP_BOOT_TEST:-}" != "1" ]]; then
  echo ""
  if ! "${ROOT}/scripts/test-boot.sh"; then
    echo "WARNING: test-boot failed (SKIP_BOOT_TEST=1 to skip)"
    [[ "${REQUIRE_BOOT_TEST:-}" == "1" ]] && exit 1
  fi
else
  echo ""
  echo "test-boot skipped (SKIP_BOOT_TEST=1)"
fi

echo ""
echo "TS-OS: Orbital app = bos-ts-orbital (φ graph, tension strip, Empty Peace, root controls)."
