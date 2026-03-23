# BOS-Full-OS — documentation index

**TS** = Thinking System / Thinking Wave (not TypeScript). See the [main README](../README.md).

| Doc | Purpose |
|-----|---------|
| [../README.md](../README.md) | Build chain, Windows PowerShell scripts, first boot checklist |
| [GITHUB.md](GITHUB.md) | Initialize git, `redox/` exclusion, push to GitHub |
| [REDOX_KERNEL_HOOK.md](REDOX_KERNEL_HOOK.md) | How `bos_ts_kernel` links into the Redox scheduler / idle path |
| [VFS-UNIVERSAL-GRAPH.md](VFS-UNIVERSAL-GRAPH.md) | UniversalLivingGraph ↔ RedoxFS design (future waves) |

## Related repository

- **[BOS](https://github.com/BoggersTheFish/BOS)** (if published) — smaller **host-side** prototype: egui `bos-shell` + kernel tick stubs. **BOS-Full-OS** adds **real Redox** cookbook recipes, **kernel vendoring**, **Orbital** `bos-ts-orbital`, and **Podman** build automation.

## What is *not* in git here

The **`redox/`** directory is **gitignored** (clone via `scripts/clone-redox.*`). Only BOS patches, recipes, and scripts live in this repo.
