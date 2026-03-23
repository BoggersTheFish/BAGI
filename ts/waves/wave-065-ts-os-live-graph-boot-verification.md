Wave 065 — ts-os-live-graph-boot-verification

**Propagate**
Activation: Wave 064 BOS-Full-OS chain extended with live Orbital desktop (`main.rs` desktop module), kernel COM1 marker `TS_IDLE_TICK_RUNNING`, `test-boot.sh`, `recipes/bos-ts-orbital/orbital.toml`, overlay rsync for `bos-ts-kernel` into orbital recipe, README First boot checklist.

**Relax / Tension detected**
Tension ~0.28: userspace `TensionRing` mirrors kernel until IPC; QEMU serial vs guest `dmesg` differs — test script documents serial capture. x86_64 COM1 write may fail on non-PC or locked ports (lowest-stability: hardware I/O path).

**Break**
Collapsed “single surface demo” into full-window graph + top strip + root panel; removed separate `redox_impl.rs` in favor of `main.rs` module.

**Evolve**
Higher-stability config: `build-podman.sh` step 6 runs `test-boot.sh` (optional strict via `REQUIRE_BOOT_TEST=1`); kernel idle emits periodic marker for grep verification.

**Final stable configuration / Answer**
Delivered: `crates/bos-ts-orbital/src/main.rs` (φ graph, realms S/Q/O, animated waves, TensionRing mirror, Empty Peace + φ slider), `patches/kernel-files/bos_ts_idle.rs` (serial marker), `scripts/test-boot.sh`, `recipes/bos-ts-orbital/orbital.toml`, `apply-overlay.sh` sync, README checklist, `build-podman.sh` integration. Commands: `chmod +x scripts/*.sh && ./scripts/build-podman.sh` (or `SKIP_BOOT_TEST=1` / `REQUIRE_BOOT_TEST=1`). First boot: top red tension bar, three-realm graph, root panel, serial line `TS_IDLE_TICK_RUNNING`.
