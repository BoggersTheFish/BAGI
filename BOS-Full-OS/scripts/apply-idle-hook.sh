#!/usr/bin/env bash
# Insert TS idle hook into kernel source tree (fn idle / idle_loop).
# TS = Thinking System (not TypeScript). Idempotent.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=/dev/null
source "${ROOT}/scripts/_ts_os_kernel_path.sh"

REDOX="${ROOT}/redox"
K="$(bos_ts_kernel_root "${REDOX}")" || {
  echo "ERROR: kernel source not found — run apply-kernel-integration.sh first."
  exit 1
}
KERNEL_SRC="${K}/src"
if [[ ! -d "${KERNEL_SRC}" ]]; then
  echo "ERROR: ${KERNEL_SRC} missing"
  exit 1
fi

python3 - "${KERNEL_SRC}" <<'PY'
import re
import sys
from pathlib import Path

kernel_src = Path(sys.argv[1])
HOOK = """    unsafe {
        crate::bos_ts_idle::ts_kernel_idle_hook();
    }
"""
prefer = ("scheduler", "context", "cpu", "idle")
candidates = sorted(
    kernel_src.rglob("*.rs"),
    key=lambda p: (
        0 if any(x in str(p).lower() for x in prefer) else 1,
        len(str(p)),
    ),
)

patched = None
for path in candidates:
    text = path.read_text(encoding="utf-8")
    if "ts_kernel_idle_hook" in text:
        print(f"Already patched: {path}")
        raise SystemExit(0)
    patterns = [
        r"(pub\s+)?fn\s+idle\s*\([^)]*\)\s*(?:->\s*[^{]+)?\{",
        r"(pub\s+)?fn\s+idle_loop\s*\([^)]*\)\s*(?:->\s*[^{]+)?\{",
    ]
    m = None
    for pat in patterns:
        m = re.search(pat, text)
        if m:
            break
    if m:
        insert_at = m.end()
        new_text = text[:insert_at] + "\n" + HOOK + text[insert_at:]
        path.write_text(new_text, encoding="utf-8")
        patched = path
        break

if patched is None:
    print(
        "ERROR: could not find `fn idle(...)` under kernel source.\n"
        "Add manually (see patches/INJECT-POINTS.md):\n"
        "  unsafe { crate::bos_ts_idle::ts_kernel_idle_hook(); }"
    )
    raise SystemExit(1)

print(f"Inserted idle hook in: {patched}")
PY
