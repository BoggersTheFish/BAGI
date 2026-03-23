# TS kernel idle — injection points (Thinking System, **not** TypeScript)

After `apply-kernel-integration.sh`, **you must** add **one** call to the idle hook.

## 1. Find candidates

From `redox/kernel/`:

```bash
rg -n "idle|Idle|IDLE|yield|schedule" src | head -40
```

Typical areas (names change by version):

- `src/context/*.rs`
- `src/arch/*/interrupt*.rs`
- `src/scheduler/*.rs` or `src/syscall/process.rs`

## 2. Insert call

Where the kernel **chooses idle work** or **returns from timer** without switching to a runnable context, add:

```rust
unsafe {
    crate::bos_ts_idle::ts_kernel_idle_hook();
}
```

If `bos_ts_idle` is not visible, use the path your `mod` declaration created (often `crate::bos_ts_idle::...`).

## 3. Build

```bash
cd redox
# follow upstream kernel build (Podman recipe builds this as part of the image)
```

## 4. Boot verification (Wave 065)

`patches/kernel-files/bos_ts_idle.rs` emits **`TS_IDLE_TICK_RUNNING`** on x86_64 COM1 every 512 idle ticks (QEMU `-serial file:`). Use `scripts/test-boot.sh` to grep the capture — not the same as running `dmesg` inside the guest without a getty.

## 5. UniversalLivingGraph ↔ RedoxFS (Wave 064+)

Mapping **inodes → `TsNodeState`** belongs in the filesystem server (`redoxfs` or equivalent), not only in this idle hook. Track as a **separate** patch series — see `docs/VFS-UNIVERSAL-GRAPH.md`.
