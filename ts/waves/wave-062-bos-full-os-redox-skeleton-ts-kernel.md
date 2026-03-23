Wave 062 — bos-full-os-redox-skeleton-ts-kernel

**Propagate**
Created `BOS-Full-OS/`: workspace `bos-ts-kernel` (`#![no_std]`, `ts_idle_tick_full`, libm sqrt), `bos-ts-shell` stub, cookbook recipes, `scripts/clone-redox.sh`, `apply-overlay.sh`, `build-podman.sh`, `docs/REDOX_KERNEL_HOOK.md`, `README.md` (honesty + boot steps), `config.toml` fragment.

**Relax / Tension detected**
Full bootable OS requires upstream Redox build + kernel/VFS patches — documented explicitly.

**Break**
N/A.

**Evolve**
Next: link crate into Redox kernel; Orbital graph UI; RedoxFS graph mapping.

**Final stable configuration / Answer**
`cargo test -p bos-ts-kernel` passes. Clone Redox → apply-overlay → Podman build per README.

Official: https://gitlab.redox-os.org/redox-os/redox · https://www.boggersthefish.com/
