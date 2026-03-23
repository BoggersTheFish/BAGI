#!/usr/bin/env bash
# Boot Redox ISO in QEMU, capture serial for 10s, grep for TS idle marker.
# TS = Thinking System (not TypeScript). Marker = COM1 line from kernel bos_ts_idle (Wave 065).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REDOX="${ROOT}/redox"
MARKER="TS_IDLE_TICK_RUNNING"
LOG="${ROOT}/target/ts-boot-serial.log"
TIMEOUT="${TEST_BOOT_SECONDS:-10}"

command -v qemu-system-x86_64 >/dev/null 2>&1 || {
  echo "ERROR: qemu-system-x86_64 not found in PATH."
  exit 1
}

ISO="$(find "${REDOX}" -type f \( -name '*.iso' -o -name 'live.iso' -o -name 'redox.iso' \) 2>/dev/null | head -1 || true)"
if [[ -z "${ISO}" ]]; then
  echo "ERROR: No bootable .iso under ${REDOX}. Run scripts/build-podman.sh first."
  exit 1
fi

mkdir -p "$(dirname "${LOG}")"
rm -f "${LOG}"

echo "test-boot: ISO=${ISO}"
echo "test-boot: serial log -> ${LOG} (wait ${TIMEOUT}s)"

set +e
qemu-system-x86_64 \
  -m 2048 \
  -cdrom "${ISO}" \
  -serial file:"${LOG}" \
  -display none \
  -no-reboot \
  -monitor none &
QPID=$!
set -e

sleep "${TIMEOUT}"
kill "${QPID}" 2>/dev/null || true
wait "${QPID}" 2>/dev/null || true

if grep -q "${MARKER}" "${LOG}" 2>/dev/null; then
  echo "SUCCESS: found ${MARKER} in serial capture (kernel idle hook active)."
  exit 0
fi

echo "FAIL: ${MARKER} not found in ${LOG} after ${TIMEOUT}s."
echo "---- tail ${LOG} ----"
tail -80 "${LOG}" 2>/dev/null || true
exit 1
