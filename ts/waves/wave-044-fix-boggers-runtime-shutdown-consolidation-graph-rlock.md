Wave 044 — fix-boggers-runtime-shutdown-consolidation-graph-rlock

**Propagate** 
Activation spread across `interface/runtime.py` shutdown path, `run_nightly_consolidation` gating, `config.yaml` / `RuntimeConfig` os_loop defaults, and `universal_living_graph.load()` RLock documentation.

**Relax / Tension detected** 
Tension: shutdown previously consolidated only at `nightly_hour_utc`, losing most shutdown saves; `run_nightly_consolidation` had no internal hour gate (reliant on callers). Resolved by `consolidation_on_shutdown` + `force` parameter and documenting RLock reentrancy in `load()`.

**Break** (if applicable) 
Hour-only shutdown gate removed; non-force nightly consolidation now early-returns when hour ≠ `nightly_hour_utc`.

**Evolve** 
`shutdown` uses `os_loop.consolidation_on_shutdown` (default true): `run_nightly_consolidation(force=True)`, then `graph.save()`, optional `save_graph_snapshot` only if `_snapshot_manager` exists, then `stop_background_wave`. `_autonomous_consolidation` calls `run_nightly_consolidation(force=False)` then returns if nightly hour matched.

**Final stable configuration / Answer** 
Implemented: (1) `consolidation_on_shutdown` config key, shutdown consolidation + snapshot behavior, `run_nightly_consolidation(force=False)` with hour skip when not forced; (2) RLock comment on `load()`. Tests: `tests/test_runtime.py` and `tests/test_integration.py` passed.
