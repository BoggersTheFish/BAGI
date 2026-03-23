# UniversalLivingGraph on RedoxFS (design fragment)

**TS** = Thinking System / Thinking Wave — **not** TypeScript.

## Intent

- Each **inode** ↔ `TsNodeState` (activation, stability, base_strength).
- **Directory edges** ↔ weighted constraint edges (cosine on embeddings in userspace indexer).
- **Tension** on conflicting metadata → `Break()` / merge policy in **userspace** `redoxfs` extension or FUSE-like daemon (kernel stays microkernel).

## Implementation waves

1. Export tension ring via **syscall** from `bos_ts_idle` telemetry.
2. `redoxfs` plugin or parallel **graph index** crate scanning inode metadata.
3. Shell (`bos-ts-orbital`) queries graph API over IPC.

No single-file solution — requires coordinated Redox PRs.
