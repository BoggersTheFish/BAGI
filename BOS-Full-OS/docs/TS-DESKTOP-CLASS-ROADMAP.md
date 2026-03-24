# TS desktop-class roadmap (Windows-class *by intent*, Redox *by substrate*)

**TS** = Thinking System / Thinking Wave — **not** TypeScript. Any future browser or installer UI may use TypeScript on the **host** only; the **OS path** stays Rust + TOML + wave manifests under `ts/`.

This document is the **authoritative in-repo contract** for what “desktop-class” means for BOS-Full-OS: comparable *intent* to Windows (reliable daily driver, installer, updates, hardware breadth, app surface) while **remaining** a Redox-based TS-OS. Work that must land in **upstream Redox** is called out explicitly — BOS-Full-OS still **owns** the TS framing, recipes, and merge instructions here.

---

## What “Windows-class” means here (measurable)

| Pillar | User-visible outcome | TS alignment |
|--------|----------------------|--------------|
| **Boot & session** | Cold boot to graph desktop; reproducible image | Idle hook + orbital surface = *live tension* visible at boot |
| **Hardware** | NIC, storage, USB, display on a defined tier list | Drivers are upstream; TS layer stays *policy* + observability hooks |
| **Shell / DE** | Full-screen Orbital app + keyboard contract | φ-spiral, tension strip, Empty Peace, root controls — already shipped |
| **Storage graph** | UniversalLivingGraph ↔ VFS (see `VFS-UNIVERSAL-GRAPH.md`) | Reconciliation waves, ingest tags, stability — future kernel/fs waves |
| **Installer** | Guided install to disk, partition map, rollback story | Installer wave = *constraint satisfaction* over disk layout |
| **Updates** | Channel + signature + atomic apply | Update wave = *tension minimization* between versions |
| **Apps** | At least one “hero” productivity path (terminal, editor, browser track) | Each app reports into graph/tension where applicable |

---

## Phases (all tracked from BOS-Full-OS)

Phase state lives in `ts/os-phases.toml` and the active wave in `ts/CURRENT-WAVE`.

### Phase 0 — **Integrated TS-OS** (current baseline)

- Recipes: `bos-ts-kernel`, `bos-ts-shell`, `bos-ts-orbital`
- Kernel: idle hook + `bos_ts_idle` integration per `REDOX_KERNEL_HOOK.md`
- Host build: `build-ts-os.sh` / `build-ts-os.ps1`
- **Done when:** ISO boots, Orbital shows TS desktop, merge `config.toml` into profile

### Phase 1 — **Profile hardening** (completed)

- **Automated merge:** `scripts/merge-bos-profile.sh` / `merge-bos-profile.ps1` run `merge_bos_into_redox_profile.py` against `redox/config/x86_64/desktop.toml` (or fallbacks / `REDOX_PROFILE`). Invoked from `build-ts-os.sh` step **[3/7]** unless `SKIP_PROFILE_MERGE=1`.
- **Tier-1 hardware:** `ts/hardware-tier.toml` (QEMU + profile paths + optional host QA notes)
- **Done when:** one-command build leaves the active Redox profile containing `bos-ts-kernel`, `bos-ts-shell`, `bos-ts-orbital` without hand-editing; tier-1 doc is the CI/dev reference
- **TS:** `CURRENT-WAVE` + `hardware-tier.toml` record the *hardware class* for the wave

### Phase 2 — **Installer wave** (stub shipped; UI upstream TBD)

- **In-repo:** `recipes/bos-ts-installer/` — `cargo` recipe, binary **`bos-ts-installer`** (console stub); listed in `config.toml` and copied by `apply-overlay.*`
- **Next:** real disk UI + alignment with upstream Redox installer; document partition constraints beside this file
- **TS:** installer = graph over partitions + user intent nodes

### Phase 3 — **Update channel** (stub shipped; fetch + crypto TBD)

- **In-repo:** [`ts/update-channel.toml`](../ts/update-channel.toml) — channel URL placeholder, signing hint, rollback slots, artifact names
- **In-repo:** `recipes/bos-ts-updater/` + **`bos-ts-updater`** binary (console stub); listed in `config.toml` and overlay
- **Next:** HTTPS fetch, signature verify, atomic apply with **`rollback.slots`**; wire to real host URLs
- **TS:** version nodes + dependency edges in manifest; failed apply = tension signal → prior graph slice

### Phase 4 — **VFS / universal graph** (stub shipped; redoxfs + IPC TBD)

- **In-repo:** [`ts/vfs-graph.toml`](../ts/vfs-graph.toml) — inode/graph mapping, IPC socket placeholder, ingest + consumers (`bos-ts-orbital`, `bos_ts_idle`)
- **In-repo:** `recipes/bos-ts-graphd/` + **`bos-ts-graphd`** (daemon stub); listed in `config.toml` and overlay
- **Next:** coordinated Redox PRs per [`VFS-UNIVERSAL-GRAPH.md`](VFS-UNIVERSAL-GRAPH.md) — syscall export, graph index, real IPC
- **TS:** filesystem events as graph ingest; reconciliation as scheduled waves

### Phase 5 — **Ecosystem**

- Browser or WebView track, office/editor, package UX
- **TS:** optional telemetry hooks (local-only) into tension pipeline

---

## What cannot live only in this repo

- **Kernel drivers** and broad **hardware enablement** → Redox + hardware donors
- **Full syscall surface** matching another OS → Redox design process
- **Legal/commercial** Windows compatibility layers → out of scope unless explicitly chosen later

BOS-Full-OS **still** owns: TS naming, recipes, patches, docs, `ts/` waves, and **how** upstream work is folded into the TS story.

---

## TypeScript boundary (explicit)

| Layer | Language |
|-------|----------|
| Kernel, recipes, Orbital, shell | Rust |
| Image config merge | TOML |
| Wave / phase registry | TOML + `CURRENT-WAVE` |
| Future web-based installer or portal (optional) | TypeScript **allowed** as UI only, not as OS implementation |

---

## Related docs

- [`README.md`](../README.md) — one-command build
- [`VFS-UNIVERSAL-GRAPH.md`](VFS-UNIVERSAL-GRAPH.md) — graph ↔ FS
- [`REDOX_KERNEL_HOOK.md`](REDOX_KERNEL_HOOK.md) — idle integration
