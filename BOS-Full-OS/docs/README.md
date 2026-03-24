# BOS-Full-OS — documentation index

**TS** = Thinking System / Thinking Wave (not TypeScript). See the [main README](../README.md).

| Doc | Purpose |
|-----|---------|
| [../README.md](../README.md) | **One command:** `build-ts-os.sh` / `build-ts-os.ps1`, kernel path auto-detect |
| [TS-DESKTOP-CLASS-ROADMAP.md](TS-DESKTOP-CLASS-ROADMAP.md) | **Desktop-class (Windows-class intent)** milestones; TS-only OS path; upstream boundaries |
| (scripts) | **`merge-bos-profile.sh`** / **`merge-bos-profile.ps1`** — Phase 1: merge `config.toml` into Redox profile |
| [GITHUB.md](GITHUB.md) | Initialize git, `redox/` exclusion, push to GitHub |
| [REDOX_KERNEL_HOOK.md](REDOX_KERNEL_HOOK.md) | How `bos_ts_kernel` links into the Redox scheduler / idle path |
| [VFS-UNIVERSAL-GRAPH.md](VFS-UNIVERSAL-GRAPH.md) | UniversalLivingGraph ↔ RedoxFS design (future waves) |

## TS wave state (in repo root)

| Path | Purpose |
|------|---------|
| [../ts/README.md](../ts/README.md) | Wave registry overview |
| [../ts/CURRENT-WAVE](../ts/CURRENT-WAVE) | Active wave + phase |
| [../ts/os-phases.toml](../ts/os-phases.toml) | Phased roadmap (TOML) |
| [../ts/update-channel.toml](../ts/update-channel.toml) | Update channel manifest stub (Phase 3) |
| [../ts/vfs-graph.toml](../ts/vfs-graph.toml) | VFS / UniversalLivingGraph contract stub (Phase 4) |

## Related repository

- **[BOS](https://github.com/BoggersTheFish/BOS)** (if published) — smaller **host-side** prototype: egui `bos-shell` + kernel tick stubs. **BOS-Full-OS** adds **real Redox** cookbook recipes, **kernel vendoring**, **Orbital** `bos-ts-orbital`, and **Podman** build automation.

## What is *not* in git here

The **`redox/`** directory is **gitignored** (clone via `scripts/clone-redox.*`). Only BOS patches, recipes, and scripts live in this repo.
