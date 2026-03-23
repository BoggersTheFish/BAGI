Wave 047 — extract-wave-runner-and-dashboard-lazy-runtime

**Propagate**
Activation spread from user request into two graph regions: (1) the `universal_living_graph._wave_loop` closure containing the full cycle step sequence, and (2) the `dashboard.app` module-level `runtime = BoggersRuntime()` eager instantiation. Linked nodes: WaveCycleRunner extraction pattern, thread ownership transfer, double-checked locking for lazy init, backward-compat property for `_wave_cycle_count`.

**Relax / Tension detected**
Tension ~0.65 on the `_wave_cycle_count` attribute removal — `autonomous_loop.py` references `self.graph._wave_cycle_count` in two places (lines 164 and 225). Lowest-stability node: the naive removal of `_wave_cycle_count` from `__init__` without a compatibility shim.

**Break**
Collapsed the "just remove the attribute" pattern. Replaced with a `@property` on `UniversalLivingGraph` that delegates to `self._wave_runner.cycle_count` when the runner exists, returning 0 otherwise. Also updated `test_dashboard_endpoints.py` to patch `get_runtime` instead of the now-removed `runtime` module variable.

**Evolve**
Higher-stability configuration:
- `core/graph/wave_runner.py`: new `WaveCycleRunner` class + `WaveConfig` dataclass. Owns thread lifecycle, stop event, cycle count, and the full step sequence (guardrails → elect → propagate → relax → prune → tension → emergence → apply → save → emit).
- `universal_living_graph.py`: `start_background_wave` creates a runner, `stop_background_wave` delegates to runner, `get_wave_status` reads from runner. `_wave_cycle_count` property provides backward compat.
- `dashboard/app.py`: eager `runtime = BoggersRuntime()` replaced with thread-safe `get_runtime()` using double-checked locking. All endpoint functions call `get_runtime()` instead of the old module-level `runtime`.
- `test_dashboard_endpoints.py`: patches `get_runtime` return value instead of `runtime`.

**Final stable configuration / Answer**
Both architectural improvements implemented and verified with 147/147 tests passing:

1. **`core/graph/wave_runner.py` extracted** — `WaveCycleRunner` owns the wave cycle step order and threading; `UniversalLivingGraph` delegates via `_wave_runner`. All public methods (`start_background_wave`, `stop_background_wave`, `get_wave_status`) preserve their signatures and return types. A `_wave_cycle_count` property ensures backward compat for internal consumers in `autonomous_loop.py`.

2. **Dashboard lazy runtime** — `BoggersRuntime()` is no longer instantiated at module import time. `get_runtime()` uses double-checked locking to create it on first call. All `runtime.xxx` replaced with `get_runtime().xxx`. Dashboard is now importable and testable without side effects.
