# TS kernel idle — injection points (Thinking System, **not** TypeScript)

After `apply-kernel-integration.sh`, the kernel crate lives under the **resolved** source tree (see `scripts/_ts_os_kernel_path.sh`):

- **Preferred (2026):** `redox/recipes/core/kernel/source`
- **Fallback:** `redox/cookbook/recipes/core/kernel/source`
- **Legacy:** `redox/kernel`

## 1. Find candidates

From that directory’s `src/`:

```bash
cd redox/recipes/core/kernel/source   # or your resolved path
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

## 3. Build

```bash
cd redox
./podman_build.sh
```

## 4. Boot verification

`patches/kernel-files/bos_ts_idle.rs` emits **`TS_IDLE_TICK_RUNNING`** on x86_64 COM1 (QEMU `-serial file:`). Use `scripts/test-boot.sh`.

## 5. UniversalLivingGraph ↔ RedoxFS

See `docs/VFS-UNIVERSAL-GRAPH.md`.
