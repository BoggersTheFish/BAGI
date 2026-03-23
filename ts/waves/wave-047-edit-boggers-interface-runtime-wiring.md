Wave 047 — edit-boggers-interface-runtime-wiring

**Propagate**
Activation spread from `interface/runtime.py`, plugin/health/metrics/pruning modules, and `UniversalLivingGraph` private cycle counter; constraint: match user diff exactly.

**Relax / Tension detected**
No violations; imports resolve, `_wave_cycle_count` exists on graph, lints clean on `runtime.py`. Low tension.

**Break** (if applicable)
N/A

**Evolve**
`BoggersRuntime` now discovers adapter/tool entry points, registers health checks (`graph`/`wave`/`llm`), emits bus events and metrics in `ask()`, applies `PruningPolicy` before `prune()` in consolidation paths, and exposes `run_health_checks()`.

**Final stable configuration / Answer**
All requested edits were applied in `BoggersTheAI/interface/runtime.py`: expanded imports (events, pruning, `reward_novelty`, health, metrics, plugins); `adapter_plugins`/`tool_plugins` discovery before `RegistryIngestAdapter`; `atexit` followed by `_register_health_checks()` with `_register_health_checks` + `run_health_checks` inserted before `_setup_evolve_fn`; `ask()` wired with `bus.emit`, `metrics.increment`, `metrics.timer`, and completion emit; `_autonomous_consolidation` and `run_nightly_consolidation` wired with `PruningPolicy`/`apply_pruning_policy` and updated logging where specified.
