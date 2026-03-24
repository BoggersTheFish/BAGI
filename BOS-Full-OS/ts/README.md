# TS (Thinking System) — OS wave registry

This folder holds **in-repo** state for evolving BOS-Full-OS toward **desktop-class** behavior (see `docs/TS-DESKTOP-CLASS-ROADMAP.md`).

| File | Role |
|------|------|
| `CURRENT-WAVE` | Active wave id + phase (human-readable) |
| `os-phases.toml` | Machine-readable phase list and package anchors |
| `hardware-tier.toml` | Tier-1 QEMU + Redox profile paths (Phase 1) |
| `update-channel.toml` | Update channel + signing + rollback placeholders (Phase 3) |
| `vfs-graph.toml` | UniversalLivingGraph ↔ VFS + IPC contract (Phase 4) |

**TS** here is **Thinking System / Thinking Wave**, not TypeScript.
