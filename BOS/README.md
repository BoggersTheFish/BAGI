# BOS — Bootable **TS-OS** (Thinking System)

> **TS** means **Thinking System / Thinking Wave** (constraint-graph cognitive architecture by Ben Michalek / [BoggersTheFish](https://github.com/BoggersTheFish)).  
> **It is not TypeScript.** For TypeScript (web UI only), see [typescriptlang.org](https://www.typescriptlang.org/docs/).

## Documentation

| | |
|--|--|
| **Index** | [`docs/README.md`](docs/README.md) |
| **GitHub (push / clone)** | [`docs/GITHUB.md`](docs/GITHUB.md) |

## Relationship to **BOS-Full-OS**

| Repo | Role |
|------|------|
| **BOS** (this folder) | Host/desktop **prototype**: **egui** `bos-shell`, `bos-kernel` tick stubs — runs with `cargo run` on Windows/Linux/macOS. |
| **[BOS-Full-OS](https://github.com/BoggersTheFish/BOS-Full-OS)** | **Bootable OS path**: `no_std` **`bos-ts-kernel`**, Redox cookbook recipes, kernel idle hook, **Orbital** `bos-ts-orbital`, Podman build scripts. |

Start here for UI experiments; use **BOS-Full-OS** when integrating into a real **Redox** image.

## What this folder is

Wave-1 **Rust skeleton** toward a Redox-inspired, TS-governed stack:

| Crate | Role |
|-------|------|
| `kernel/` (`bos-kernel`) | Stubs for **Propagate → Relax → tension** idle tick; φ constant; future Redox scheduler hook |
| `bos-shell/` | **egui** desktop window — tension panel, placeholder “portal” |

Future waves: inode↔node VFS, egui graph viz, BoggersTheAI-style services, QLoRA console.

## Official TS (Thinking System) links

- Portal: [boggersthefish.com](https://www.boggersthefish.com/)
- [GOAT-TS](https://github.com/BoggersTheFish/GOAT-TS)
- [BoggersTheAI](https://github.com/BoggersTheFish/BoggersTheAI)
- [TS-Core](https://github.com/BoggersTheFish/TS-Core) · [BoggersTheMind](https://github.com/BoggersTheFish/BoggersTheMind)

## Base OS reference (Rust microkernel)

- [Redox OS](https://www.redox-os.org/) · [redox-os/redox](https://github.com/redox-os/redox)

## Build & run (Windows / Linux / macOS)

```bash
cd BOS
cargo run -p bos-shell
```

Requires [Rust toolchain](https://rustup.rs/) (stable).

## Next wave (plan)

1. Split `bos-kernel` tick into explicit `propagate` / `relax` / `break_weak` with ring-buffer tension export.
2. egui **live graph** view (nodes/edges) — port concepts from BoggersTheAI dashboard.
3. Optional `no_std` kernel crate target — wire to Redox upstream when fork is ready.

## References (spec)

- EEG / φ: [Kramer 2022 PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC10181851/), [Frontiers 2026](https://www.frontiersin.org/journals/human-neuroscience/articles/10.3389/fnhum.2026.1781338/full), [Lacy 2026 Zenodo](https://zenodo.org/) (per your spec — verify exact DOI as needed).
- Pineal / neuromodulation: [PMC7145358](https://pmc.ncbi.nlm.nih.gov/articles/PMC7145358/)
- Many-worlds (interpretation slice): [Wikipedia](https://en.wikipedia.org/wiki/Many-worlds_interpretation)
