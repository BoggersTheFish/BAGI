#!/usr/bin/env bash
# One-shot: clone Redox (if needed) → overlay recipes → kernel TS integration → idle hook
# → Podman build → print ISO + QEMU hint → optional test-boot (SKIP_BOOT_TEST=1 to skip).
# Requires: Linux or WSL2, Podman, git, Python 3 (no rsync — uses cp -R).
# TS = Thinking System / Thinking Wave (not TypeScript).

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT}"

echo "=== [1/6] clone Redox (if missing) ==="
if [[ ! -d "${ROOT}/redox/.git" ]]; then
  "${ROOT}/scripts/clone-redox.sh"
else
  echo "redox/ exists, skipping clone."
fi

echo "=== [2/6] cookbook overlay ==="
"${ROOT}/scripts/apply-overlay.sh"

echo "=== [3/6] kernel TS integration (vendor + mod) ==="
"${ROOT}/scripts/apply-kernel-integration.sh"

echo "=== [3b/6] idle hook (ts_idle_tick_full via ts_kernel_idle_hook) ==="
if ! "${ROOT}/scripts/apply-idle-hook.sh"; then
  echo "WARNING: apply-idle-hook.sh failed — add hook manually (patches/INJECT-POINTS.md)"
fi

echo "=== [4/6] Podman build (upstream Redox) ==="
cd "${ROOT}/redox"
if [[ -f ./podman_build.sh ]]; then
  ./podman_build.sh "$@"
elif [[ -f ./podman-bootstrap.sh ]]; then
  ./podman-bootstrap.sh "$@"
else
  echo "No podman_build.sh — open https://doc.redox-os.org/book/building-the-redox-os.html"
  exit 1
fi

echo ""
echo "=== [5/6] locate bootable image ==="
cd "${ROOT}/redox"
ISO="$(find . -type f \( -name '*.iso' -o -name 'live.iso' -o -name 'redox.iso' \) 2>/dev/null | head -1 || true)"
if [[ -n "${ISO}" ]]; then
  echo "Found image: ${ISO}"
  echo ""
  echo "QEMU (adjust memory/path):"
  echo "  qemu-system-x86_64 -m 2048 -cdrom \"${ROOT}/redox/${ISO}\" -enable-kvm"
  echo ""
  echo "Or from redox/:"
  echo "  make run"
else
  echo "ISO not found under redox/ — search build/ artifacts per upstream docs."
fi

if [[ "${SKIP_BOOT_TEST:-}" == "1" ]]; then
  echo ""
  echo "=== [6/6] boot test SKIPPED (SKIP_BOOT_TEST=1) ==="
else
  echo ""
  echo "=== [6/6] boot verification (QEMU serial → TS_IDLE_TICK_RUNNING) ==="
  if ! "${ROOT}/scripts/test-boot.sh"; then
    echo "WARNING: test-boot.sh failed — kernel serial marker missing or QEMU issue."
    echo "         Set SKIP_BOOT_TEST=1 to skip, or REQUIRE_BOOT_TEST=1 to fail the build on error."
    if [[ "${REQUIRE_BOOT_TEST:-}" == "1" ]]; then
      exit 1
    fi
  fi
fi
