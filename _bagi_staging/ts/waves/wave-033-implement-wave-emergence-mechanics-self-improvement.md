Wave 033 — implement-wave-emergence-mechanics-self-improvement

**Propagate**
Activation spread across: rules_engine.py (detect_tension, spawn_emergence, run_rules_cycle), wave_propagation.py (propagate), universal_living_graph.py (_wave_loop, _resolve_wave_settings), runtime.py (fine_tune_and_hotswap), config.yaml (fine_tuning), fine_tuner.py (FineTuningConfig). Key active nodes: per-type thresholds, wave damping, merge/split/novelty rules, telemetry logging, safety caps, quality gate, lineage tracking, multi-model presets.

**Relax / Tension detected**
Tension ~0.65 — multiple subsystems needed coordinated updates; lowest-stability node was the hardcoded 0.2 threshold in detect_tension (no type awareness). Secondary tension: no damping in propagate causing runaway activation, no safety cap on node count, no quality gate before hotswap.

**Break**
Collapsed the single-threshold detect_tension pattern and undamped propagate. Collapsed the bare run_rules_cycle without merge/split. Collapsed unguarded hotswap flow.

**Evolve**
- Per-type stability thresholds (_TYPE_STABILITY_THRESHOLDS) with fallback
- Wave damping factor (0.95) in propagate with bounded activation [0,1]
- merge_similar_topics, split_overactivated, reward_novelty rules
- run_rules_cycle now calls merge → split → detect_tension → spawn_emergence
- Telemetry logging on every spawn/merge/split event
- Safety cap: node count > max_nodes_per_cycle * 200 triggers warning
- Quality gate: _run_quality_gate tests new adapter before hotswap
- Fine-tune lineage node stored in graph after successful hotswap
- supported_models preset list in config.yaml

**Final stable configuration / Answer**
All requested improvements implemented across 5 files:

1. **rules_engine.py** — `detect_tension` now uses `_TYPE_STABILITY_THRESHOLDS` with per-node-type thresholds (conversation=0.15, insight=0.25, emergent=0.3, autonomous/default=0.2). Added `merge_similar_topics`, `split_overactivated`, `reward_novelty`. `run_rules_cycle` calls merge → split → tensions → emergence. Logger added for spawn/merge/split telemetry.

2. **wave_propagation.py** — `propagate` takes `damping=0.95` parameter, activation bounded to [0.0, 1.0].

3. **universal_living_graph.py** — `_resolve_wave_settings` includes `max_nodes_per_cycle: 50`. `_wave_loop` checks node count against safety cap (max_nodes_per_cycle * 200).

4. **runtime.py** — `fine_tune_and_hotswap` runs `_run_quality_gate` before hotswap when validation_enabled. After successful hotswap, stores a `finetune_lineage` node in the graph with adapter path, epochs, loss, val_loss, wave_cycle, and timestamp.

5. **config.yaml** — Added `supported_models` list under `fine_tuning` with llama-3.2-1b, Phi-3-mini-4k, gemma-2-2b presets.
