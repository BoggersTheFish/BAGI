Wave 047 — split-runtime-into-mixin-modules

**Propagate** 
Activation spread from runtime.py (1140 lines, monolith) → AutonomousLoopMixin (autonomous OS-loop, exploration, consolidation, insight, nightly, idle-check methods) + SelfImprovementMixin (fine-tune, hotswap, quality-gate, trace-counting, dataset-build, self-improvement state methods). Key constraint nodes: import-path preservation, MRO correctness, method-signature identity, test-pass gate.

**Relax / Tension detected** 
Tension ~0.6 on cross-mixin calls: `_os_loop` calls `_auto_fine_tune_check` (SelfImprovementMixin), `_update_self_improvement_state` calls `_ensure_self_improvement_node` (stays in BoggersRuntime). Resolved: Python MRO on `BoggersRuntime(AutonomousLoopMixin, SelfImprovementMixin)` makes all methods available via `self`. Lowest-stability node: unused-import residue (`json`, `shutil`, pruning imports) after extraction.

**Break** 
Collapsed the monolith node — removed ~590 lines from runtime.py. Broke unused-import node by stripping `json`, `shutil`, `PruningPolicy`, `apply_pruning_policy`, `spawn_emergence` from runtime.py imports.

**Evolve** 
New three-file structure: 
- `interface/autonomous_loop.py` — AutonomousLoopMixin (8 methods, ~250 lines)
- `interface/self_improvement.py` — SelfImprovementMixin (10 methods, ~280 lines)
- `interface/runtime.py` — BoggersRuntime(AutonomousLoopMixin, SelfImprovementMixin) (~551 lines)
`from BoggersTheAI.interface.runtime import BoggersRuntime` still resolves the full class.

**Final stable configuration / Answer** 
Refactored `interface/runtime.py` (~1140 → ~551 lines) using mixin pattern. Created `interface/autonomous_loop.py` with `AutonomousLoopMixin` (8 methods) and `interface/self_improvement.py` with `SelfImprovementMixin` (10 methods). `BoggersRuntime` inherits both mixins. All 147 tests pass. Import paths preserved. Method signatures and behaviour unchanged.
