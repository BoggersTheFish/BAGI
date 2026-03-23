#!/usr/bin/env bash
# Insert TS idle hook into Redox kernel idle path (calls ts_kernel_idle_hook → ts_idle_tick_full).
# TS = Thinking System (not TypeScript). Idempotent.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
K="${ROOT}/redox/kernel/src"
if [[ ! -d "${K}" ]]; then
  echo "ERROR: ${K} missing — run clone-redox.sh and apply-kernel-integration.sh first."
  exit 1
fi

python3 - "${K}" <<'PY'
import re
import sys
from pathlib import Path

kernel_src = Path(sys.argv[1])
HOOK = """    unsafe {
        crate::bos_ts_idle::ts_kernel_idle_hook();
    }
"""
# Prefer files whose path hints at scheduler / context / idle
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
    # Match: pub fn idle ... {  or fn idle ... {
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
        "ERROR: could not find `fn idle(...)` in kernel/src/**/*.rs.\n"
        "Add manually (see patches/INJECT-POINTS.md):\n"
        "  unsafe { crate::bos_ts_idle::ts_kernel_idle_hook(); }"
    )
    raise SystemExit(1)

print(f"Inserted idle hook in: {patched}")
PY
