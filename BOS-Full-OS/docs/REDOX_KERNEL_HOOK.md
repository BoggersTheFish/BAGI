# Hooking `bos_ts_kernel` into the Redox scheduler

**TS** = Thinking System / Thinking Wave — not TypeScript.

This is **not** a one-line patch: you must integrate with the Redox kernel tree.

**Automated path (Wave 064+):** run `scripts/apply-kernel-integration.sh` (vendors `bos_ts_kernel`, installs `bos_ts_idle.rs`), then `scripts/apply-idle-hook.sh` (inserts `ts_kernel_idle_hook()` into the first matching `fn idle` / `fn idle_loop`). Static buffers live in `patches/kernel-files/bos_ts_idle.rs` (calls `ts_idle_tick_full`).

## Intended call site

1. Clone [Redox](https://gitlab.redox-os.org/redox-os/redox) (see `../scripts/clone-redox.sh`).
2. Open the kernel scheduler / idle loop in `redox/kernel` (exact path varies by Redox version).
3. Add a **static** graph buffer + `TensionRing<256>` in the kernel’s BSS or per-CPU struct.
4. On each idle iteration (or timer tick), call:

   ```rust
   use bos_ts_kernel::{ts_idle_tick_full, TsNodeState, TensionRing, MAX_NODES};

   static mut TS_NODES: [TsNodeState; MAX_NODES] = [TsNodeState {
       activation: 0.0,
       base_strength: 0.5,
       stability: 1.0,
   }; MAX_NODES];
   static mut TS_COUNT: usize = 0;
   static mut TS_RING: TensionRing<256> = TensionRing::new();
   static mut EMPTY_PEACE: bool = false;

   // unsafe { ts_idle_tick_full(&mut TS_NODES, &mut TS_COUNT, &mut TS_RING, EMPTY_PEACE); }
   ```

5. Expose `TS_RING.last()` via **syscall** or **shared memory page** for `bos-ts-shell`.

## VFS = UniversalLivingGraph

Mapping inodes → `TsNodeState` requires coordinated changes in **RedoxFS** or a new FUSE-like layer; this repo only provides the **numeric** graph core. Track that work in a separate PR.

## References

- [Redox book — Building](https://doc.redox-os.org/book/building-the-redox-os.html)
- [GOAT-TS](https://github.com/BoggersTheFish/GOAT-TS)
- φ / EEG: [PMC10181851](https://pmc.ncbi.nlm.nih.gov/articles/PMC10181851/)
