Wave 071 — ts-os-build-ts-os-kernel-path

**Propagate**
BOS-Full-OS: kernel injection targets **2026** `recipes/core/kernel/source` via `_ts_os_kernel_path.sh`/`.ps1` (fallbacks: cookbook path, legacy `kernel`); removed hardcoded `redox/kernel` from scripts; `build-ts-os.sh` + `build-ts-os.ps1` one-command chain; `build-podman.*` thin wrappers; README minimal (Git Bash + PowerShell); INJECT-POINTS + REDOX_KERNEL_HOOK updated; setup-windows lists `build-ts-os.ps1` first.

**Relax / Tension detected**
If no path matches, scripts print tried paths — user aligns Redox checkout revision.

**Break**
Dropped single-path `redox/kernel` assumption.

**Evolve**
Stable entry: `./scripts/build-ts-os.sh` or `.\scripts\build-ts-os.ps1`.

**Final stable configuration / Answer**
`./scripts/build-ts-os.sh` — clone, overlay, kernel vendor, idle hook, podman, QEMU line, optional test-boot.
