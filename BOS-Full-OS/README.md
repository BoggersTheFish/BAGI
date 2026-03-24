# BOS-Full-OS — **TS**-native integration for [Redox OS](https://redox-os.org/)

**TS** means **Thinking System / Thinking Wave** (constraint-graph cognition — Ben Michalek / [BoggersTheFish](https://github.com/BoggersTheFish)).  
**It is not TypeScript.** Use [typescriptlang.org](https://www.typescriptlang.org/docs/) **only** for any future web UI bridge.

BOS-Full-OS is a **Redox integration layer**: it vendors TS kernel hooks, ships **cookbook** recipes, and carries **manifests + scripts** so a bootable image can include the TS stack. It is **not** a replacement for upstream [Redox](https://gitlab.redox-os.org/redox-os/redox); broad hardware, drivers, and core OS evolution still come from there.

---

## What we have today

| Area | Status |
|------|--------|
| **Kernel** | `bos-ts-kernel` + idle hook (`ts_idle_tick_full` / `bos_ts_idle`) — see [`docs/REDOX_KERNEL_HOOK.md`](docs/REDOX_KERNEL_HOOK.md) |
| **Desktop / Orbital** | `bos-ts-orbital` — φ-spiral graph, tension strip, Empty Peace, root controls (**P**, **`[`** **`]`**, **1** / **2**) |
| **Shell stub** | `bos-ts-shell` |
| **Image profile** | [`config.toml`](config.toml) lists packages; [`scripts/merge-bos-profile.sh`](scripts/merge-bos-profile.sh) merges them into the Redox profile (Phase 1). Tier-1 dev reference: [`ts/hardware-tier.toml`](ts/hardware-tier.toml) |
| **Installer wave (stub)** | `bos-ts-installer` — placeholder binary; real disk UI + upstream installer alignment later |
| **Update channel (stub)** | `bos-ts-updater` + [`ts/update-channel.toml`](ts/update-channel.toml) — placeholders for URL, signing, rollback |
| **VFS / graph (stub)** | `bos-ts-graphd` + [`ts/vfs-graph.toml`](ts/vfs-graph.toml) — contract for UniversalLivingGraph ↔ FS; design in [`docs/VFS-UNIVERSAL-GRAPH.md`](docs/VFS-UNIVERSAL-GRAPH.md) |
| **CI** | [`.github/workflows/profile-merge.yml`](.github/workflows/profile-merge.yml) — smoke-test for profile merge script |
| **Wave / phase state** | [`ts/CURRENT-WAVE`](ts/CURRENT-WAVE), [`ts/os-phases.toml`](ts/os-phases.toml) |

The **`redox/`** tree is **not** committed (clone via [`scripts/clone-redox.sh`](scripts/clone-redox.sh) / `.ps1`); see repo [`../.gitignore`](../.gitignore) in the parent workspace.

---

## What we aim to make

We are driving toward a **desktop-class TS-OS** on Redox: **intent** comparable to Windows or mainstream Linux (reliable session, installer story, updates, storage/graph integration, app surface), with **TS** (graphs, tension, waves) wired through kernel idle, UI, and future VFS — not a Windows NT clone.

Honest boundary: **full** “Windows-class” breadth (every device class, commercial app ecosystem) requires **years of upstream kernel and driver work** outside this repo. BOS-Full-OS **owns** the TS framing, recipes, patches, manifests, and how that story merges with Redox.

Full narrative and pillars: [`docs/TS-DESKTOP-CLASS-ROADMAP.md`](docs/TS-DESKTOP-CLASS-ROADMAP.md).

---

## Steps we are taking (phased)

Tracked in [`ts/os-phases.toml`](ts/os-phases.toml). Summary:

| Phase | Focus | State (as of this README) |
|-------|--------|---------------------------|
| **0** | Integrated TS-OS — kernel hook + shell + Orbital | Baseline |
| **1** | Profile hardening — auto-merge BOS packages into Redox profile, tier-1 hardware doc | Completed |
| **2** | Installer wave | Stub (`bos-ts-installer`) |
| **3** | Update channel | Stub (`bos-ts-updater`, `ts/update-channel.toml`) |
| **4** | VFS / universal graph | Stub (`bos-ts-graphd`, `ts/vfs-graph.toml`) |
| **5** | Ecosystem / “hero” apps (browser, editor, package UX, etc.) | Next |

Active wave line: [`ts/CURRENT-WAVE`](ts/CURRENT-WAVE).

---

## One command (use this)

**Kernel source** is auto-detected (2026 layout first):

1. `redox/recipes/core/kernel/source`
2. `redox/cookbook/recipes/core/kernel/source`
3. `redox/kernel` (legacy)

All file copies use **`cp -R`** / **`Copy-Item`** — **no rsync**.

### Git Bash / WSL / Linux

```bash
cd BOS-Full-OS
chmod +x scripts/build-ts-os.sh
./scripts/build-ts-os.sh
```

Optional: `SKIP_BOOT_TEST=1 ./scripts/build-ts-os.sh` if you skip QEMU serial test.  
Optional: `SKIP_PROFILE_MERGE=1` to skip merging [`config.toml`](config.toml) into the Redox profile.

### Windows PowerShell

Install **Git for Windows** (includes **Git Bash**) — Podman build runs inside bash.

```powershell
cd BOS-Full-OS
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned   # once, if blocked
.\scripts\setup-windows.ps1    # optional: checks python, git, bash, qemu, podman
.\scripts\build-ts-os.ps1
```

`build-ts-os.ps1` runs **`build-ts-os.sh`** via Git Bash or WSL so paths match Redox scripts.

---

## What the build does

1. Clone [redox](https://gitlab.redox-os.org/redox-os/redox) if `redox/` is missing  
2. **`apply-overlay`** — copy BOS recipes into `redox/cookbook/recipes/` (`bos-ts-kernel`, `bos-ts-shell`, `bos-ts-orbital`, `bos-ts-installer`, `bos-ts-updater`, `bos-ts-graphd`)  
3. **`merge-bos-profile`** — merge [`config.toml`](config.toml) `[packages]` into the resolved Redox profile (unless `SKIP_PROFILE_MERGE=1`)  
4. **`apply-kernel-integration`** — vendor `bos-ts-kernel` into resolved kernel tree, add `bos_ts_idle.rs`, patch `Cargo.toml` + `lib.rs`  
5. **`apply-idle-hook`** — insert `ts_kernel_idle_hook()` (or see [`patches/INJECT-POINTS.md`](patches/INJECT-POINTS.md))  
6. **`redox/podman_build.sh`** — upstream Podman build  
7. Print **ISO path** + **QEMU** line; optional **`test-boot.sh`**

**Profile override:** set **`REDOX_PROFILE`** to a full path if your image config is not `config/x86_64/desktop.toml` (see [`ts/hardware-tier.toml`](ts/hardware-tier.toml)).

---

## Documentation

| | |
|--|--|
| **Index** | [`docs/README.md`](docs/README.md) |
| **TS desktop-class roadmap** | [`docs/TS-DESKTOP-CLASS-ROADMAP.md`](docs/TS-DESKTOP-CLASS-ROADMAP.md) |
| **TS wave registry** | [`ts/README.md`](ts/README.md), [`ts/CURRENT-WAVE`](ts/CURRENT-WAVE), [`ts/os-phases.toml`](ts/os-phases.toml), [`ts/update-channel.toml`](ts/update-channel.toml), [`ts/vfs-graph.toml`](ts/vfs-graph.toml) |
| **Kernel hook** | [`docs/REDOX_KERNEL_HOOK.md`](docs/REDOX_KERNEL_HOOK.md) |
| **VFS / graph** | [`docs/VFS-UNIVERSAL-GRAPH.md`](docs/VFS-UNIVERSAL-GRAPH.md) |

---

## Relationship to **BOS**

| Repo | Role |
|------|------|
| **[BOS](https://github.com/BoggersTheFish/BOS)** | Host **egui** prototype — no Redox clone. |
| **BOS-Full-OS** | **Bootable TS-OS** path — this tree. **`redox/`** is cloned locally, not stored in git here. |

---

## First boot (graph desktop)

Launch **`bos-ts-orbital`**: φ layout, tension bar, Empty Peace + φ slider — see repo history for UI detail.

---

## Script reference (advanced)

| Step | Bash | PowerShell |
|------|------|------------|
| One-shot build | `./scripts/build-ts-os.sh` | `.\scripts\build-ts-os.ps1` |
| Same (legacy name) | `./scripts/build-podman.sh` | `.\scripts\build-podman.ps1` |
| Merge BOS into Redox profile | `./scripts/merge-bos-profile.sh` | `.\scripts\merge-bos-profile.ps1` |
| Clone Redox only | `./scripts/clone-redox.sh` | `.\scripts\clone-redox.ps1` |
| Boot test | `./scripts/test-boot.sh` | `.\scripts\test-boot.ps1` |

---

## Host development (crate tests)

```bash
cd BOS-Full-OS
cargo test -p bos-ts-kernel
cargo check -p bos-ts-installer
cargo check -p bos-ts-updater
cargo check -p bos-ts-graphd
rustup target add x86_64-unknown-redox
cargo check -p bos-ts-orbital --target x86_64-unknown-redox
```

---

## Official TS (Thinking System) links

- [boggersthefish.com](https://www.boggersthefish.com/)
- [GOAT-TS](https://github.com/BoggersTheFish/GOAT-TS)
- [Redox](https://gitlab.redox-os.org/redox-os/redox)
