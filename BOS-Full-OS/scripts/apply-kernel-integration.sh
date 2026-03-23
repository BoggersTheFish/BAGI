#!/usr/bin/env bash
# Vendor bos-ts-kernel into redox/kernel and install bos_ts_idle.rs + Cargo.toml + mod.
# TS = Thinking System (not TypeScript).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
K="${ROOT}/redox/kernel"
if [[ ! -d "${K}" ]]; then
  echo "ERROR: ${K} not found. Run scripts/clone-redox.sh first."
  exit 1
fi

echo "[1/4] copy bos-ts-kernel → kernel/bos_ts_kernel (no rsync)"
rm -rf "${K}/bos_ts_kernel"
mkdir -p "${K}/bos_ts_kernel"
cp -R "${ROOT}/crates/bos-ts-kernel/." "${K}/bos_ts_kernel/"

echo "[2/4] install bos_ts_idle.rs"
cp "${ROOT}/patches/kernel-files/bos_ts_idle.rs" "${K}/src/bos_ts_idle.rs"

echo "[3/4] patch kernel Cargo.toml"
python3 << PY
from pathlib import Path
import re
cargo = Path(r"${K}/Cargo.toml")
text = cargo.read_text(encoding="utf-8")
if "bos_ts_kernel" in text:
    print("  (bos_ts_kernel already in Cargo.toml)")
else:
    if "[dependencies]" in text:
        text = re.sub(
            r"(\[dependencies\]\n)",
            r'\1bos_ts_kernel = { path = "bos_ts_kernel" }\n',
            text,
            count=1,
        )
    else:
        text += '\n[dependencies]\nbos_ts_kernel = { path = "bos_ts_kernel" }\n'
    cargo.write_text(text, encoding="utf-8")
    print("  appended bos_ts_kernel path dependency")
PY

echo "[4/4] insert mod bos_ts_idle in src/lib.rs"
python3 << PY
from pathlib import Path
p = Path(r"${K}/src/lib.rs")
text = p.read_text(encoding="utf-8")
if "mod bos_ts_idle" in text:
    print("  (mod bos_ts_idle already present)")
else:
    lines = text.splitlines(keepends=True)
    out = []
    inserted = False
    for line in lines:
        out.append(line)
        if line.startswith("#![no_std]") and not inserted:
            out.append("mod bos_ts_idle;\n")
            inserted = True
    if not inserted:
        out.insert(0, "mod bos_ts_idle;\n")
    p.write_text("".join(out), encoding="utf-8")
    print("  inserted mod bos_ts_idle")
PY

echo ""
echo "DONE. Next: edit scheduler idle path per patches/INJECT-POINTS.md"
echo "Then: cd redox && ./podman_build.sh (or scripts/build-podman.sh)"
