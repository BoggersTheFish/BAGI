# BOS-Full-OS — **TS**-native integration for [Redox OS](https://redox-os.org/)

**TS** means **Thinking System / Thinking Wave** (constraint-graph cognition — Ben Michalek / [BoggersTheFish](https://github.com/BoggersTheFish)).  
**It is not TypeScript.** Use [typescriptlang.org](https://www.typescriptlang.org/docs/) **only** for any future web UI bridge.

## Documentation

| | |
|--|--|
| **Index** | [`docs/README.md`](docs/README.md) |
| **GitHub (push / clone)** | [`docs/GITHUB.md`](docs/GITHUB.md) |
| **Kernel hook** | [`docs/REDOX_KERNEL_HOOK.md`](docs/REDOX_KERNEL_HOOK.md) |
| **VFS / graph (future)** | [`docs/VFS-UNIVERSAL-GRAPH.md`](docs/VFS-UNIVERSAL-GRAPH.md) |

## Relationship to **BOS**

| Repo | Role |
|------|------|
| **[BOS](https://github.com/BoggersTheFish/BOS)** | Lighter **egui** desktop + kernel **stubs** — quick iteration without cloning Redox. |
| **BOS-Full-OS** (this repo) | **Production integration** into [Redox OS](https://redox-os.org/): vendored kernel crate, scripts, ISO build. The **`redox/`** checkout is **not** committed (see `docs/GITHUB.md`). |

This repository wires **real** `no_std` **`bos-ts-kernel`** logic (`ts_idle_tick_full`) into the **Redox kernel idle path**, ships **cookbook** recipes, and adds an **Orbclient** graph shell (**`bos-ts-orbital`**) for Orbital with a φ-scaled live graph + tension strip.

### Windows users: run `setup-windows.ps1` once

From **PowerShell** at the repo root (right-click → Run as Administrator *not* required):

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned   # if scripts are blocked
.\scripts\setup-windows.ps1
```

That checks **Python**, **Git**, **Git Bash** (needed for upstream `redox/podman_build.sh`), **QEMU**, **Podman**, and **WSL**, and prints next steps. Then use the **native `.ps1` scripts** under `scripts/` (same behavior as the `.sh` scripts — **no rsync**; everything uses `cp -R` / `Copy-Item`).

| Step | Bash (Git Bash / WSL / Linux) | Windows PowerShell |
|------|------------------------------|---------------------|
| Clone Redox | `./scripts/clone-redox.sh` | `.\scripts\clone-redox.ps1` |
| Overlay | `./scripts/apply-overlay.sh` | `.\scripts\apply-overlay.ps1` |
| Kernel integration | `./scripts/apply-kernel-integration.sh` | `.\scripts\apply-kernel-integration.ps1` |
| Idle hook | `./scripts/apply-idle-hook.sh` | `.\scripts\apply-idle-hook.ps1` |
| Full build | `./scripts/build-podman.sh` | `.\scripts\build-podman.ps1` |
| Boot test | `./scripts/test-boot.sh` | `.\scripts\test-boot.ps1` |

---

## One-command build chain (Linux / WSL2 + Podman)

From the repo root:

```bash
chmod +x scripts/*.sh
./scripts/build-podman.sh
```

This will:

1. Clone [redox](https://gitlab.redox-os.org/redox-os/redox) if `redox/` is missing  
2. Copy BOS recipes into `redox/cookbook/recipes/` (`apply-overlay.sh`)  
3. Vendor `bos-ts-kernel` into `redox/kernel/bos_ts_kernel`, add `bos_ts_idle.rs`, patch `Cargo.toml` + `lib.rs` (`apply-kernel-integration.sh`)  
4. Try to inject `ts_kernel_idle_hook()` into the first `fn idle` found under `redox/kernel/src` (`apply-idle-hook.sh`)  
5. Run Redox’s `./podman_build.sh` and print a **`find`** hint for `*.iso` + a **QEMU** one-liner  
6. Run **`scripts/test-boot.sh`** (unless `SKIP_BOOT_TEST=1`): boots the ISO in QEMU, captures **serial** for 10s, greps for **`TS_IDLE_TICK_RUNNING`** (emitted from `patches/kernel-files/bos_ts_idle.rs` on x86_64 COM1 — same string you would expect in kernel/dmesg-style logs when serial is bridged).

**Merge `config.toml` (packages section)** into the Redox profile you build (e.g. `redox/config/x86_64/desktop.toml`) so `bos-ts-kernel`, `bos-ts-shell`, and `bos-ts-orbital` are on the image. Exact TOML layout follows upstream — compare before merging.

**Orbital launcher metadata:** `recipes/bos-ts-orbital/orbital.toml` (primary) — legacy copy under `recipes/bos-ts-shell/orbital.toml` may still exist; prefer the bos-ts-orbital path.

**Skip QEMU test:** `SKIP_BOOT_TEST=1 ./scripts/build-podman.sh` if you have no `qemu-system-x86_64` or need to defer verification.

---

## Exact manual steps (same as the script, piecewise)

```bash
cd BOS-Full-OS
chmod +x scripts/*.sh
./scripts/clone-redox.sh
./scripts/apply-overlay.sh
./scripts/apply-kernel-integration.sh
./scripts/apply-idle-hook.sh   # or apply patches/redox-kernel-ts-hook.diff intent by hand
./scripts/build-podman.sh
# or from redox/:
cd redox && ./podman_build.sh
```

After a successful build:

```bash
cd redox
find . -name '*.iso' | head
make run
# or:
# qemu-system-x86_64 -m 2048 -cdrom path/to/live.iso -enable-kvm
```

ISO path **depends on Redox revision** — use `find` as above.

---

## First boot checklist (Wave 065 — what you should see)

1. **Kernel:** After idle runs, serial (or bridged log) contains **`TS_IDLE_TICK_RUNNING`** periodically — confirms `ts_idle_tick_full` runs via `ts_kernel_idle_hook` (see `patches/kernel-files/bos_ts_idle.rs`).  
2. **Graph desktop:** Launch **`bos-ts-orbital`** from Orbital (or autostart per your image). You should see:
   - **Full-window** dark “spacetime” background with **animated φ wave** bands and a decorative quantum trace.
   - **Cytoscape-style** graph: **~64 nodes** in three realms (**S**pacetime, **Q**uantum, **O**rphans), **φ-resonance** spiral layout, **ring + root-star** edges, pulsing node radii.
   - **Top tension strip** — live bar driven by **`TensionRing` mirror** (userspace runs the same `ts_idle_tick_full` as the kernel graph until IPC lands).
   - **Root Node Controls** — bottom panel: **[P]** toggles **Empty Peace** (global Relax path in the tick), **`[`** / **`]`** adjust **φ-resonance** slider (0.5–2.5), **[1]/[2]** nudge root activation.
3. **Screenshot expectation:** Fullscreen-ish window (~1280×800 default), **red tension bar** under the top caption line, **colored nodes** (blue / cyan / orange families), **slider knob** on the bottom panel, **no** separate “demo” watermark — this is the live TS shell.

4. **Verification script:** `./scripts/test-boot.sh` — does **not** run `dmesg` inside the guest; it captures **QEMU serial** to `target/ts-boot-serial.log` (equivalent to kernel log for CI). Override wait with `TEST_BOOT_SECONDS=30`.

---

## Repository layout

```
BOS-Full-OS/
├── Cargo.toml                 # workspace: bos-ts-kernel, bos-ts-shell, bos-ts-orbital
├── config.toml                # merge [packages] into upstream Redox config
├── crates/
│   ├── bos-ts-kernel/         # #![no_std] TS idle loop (vendored into redox/kernel)
│   ├── bos-ts-shell/          # userspace stub
│   └── bos-ts-orbital/        # Orbclient TS-OS desktop (Redox); host prints stub
├── recipes/                   # cookbook templates → copied into redox/cookbook/recipes/
├── scripts/
│   ├── clone-redox.sh | clone-redox.ps1
│   ├── apply-overlay.sh | apply-overlay.ps1   (+ _copy_tree.ps1)
│   ├── apply-kernel-integration.sh | apply-kernel-integration.ps1
│   ├── apply-idle-hook.sh | apply-idle-hook.ps1
│   ├── build-podman.sh | build-podman.ps1
│   ├── test-boot.sh | test-boot.ps1
│   └── setup-windows.ps1
├── patches/
│   ├── redox-kernel-ts-hook.diff   # semantic / example (use apply-idle-hook.sh)
│   ├── INJECT-POINTS.md
│   └── kernel-files/bos_ts_idle.rs
├── docs/
└── redox/                     # populated by clone script
```

---

## Kernel integration (honesty)

- **`apply-kernel-integration.sh`** vendors the crate and installs the idle module.  
- **`apply-idle-hook.sh`** searches for `fn idle` — if upstream renames it, use `patches/INJECT-POINTS.md` and patch by hand.  
- **UniversalLivingGraph on RedoxFS** is specified in `docs/VFS-UNIVERSAL-GRAPH.md` (future wave).

---

## Host development

```bash
cd BOS-Full-OS
cargo test -p bos-ts-kernel
cargo run -p bos-ts-shell
# bos-ts-orbital: stub on non-Redox; full UI:
rustup target add x86_64-unknown-redox
cargo check -p bos-ts-orbital --target x86_64-unknown-redox
```

---

## Official TS (Thinking System) links

- [boggersthefish.com](https://www.boggersthefish.com/)
- [GOAT-TS](https://github.com/BoggersTheFish/GOAT-TS)
- [Redox](https://gitlab.redox-os.org/redox-os/redox)
