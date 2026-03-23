Wave 024 — implement-improvements-core-graph-wave-query

**Propagate**
Activation spread across six task nodes: 2.2 (configurable wave params), 2.3 (delete orphaned edge.py), 2.4 (JSON validation), 2.5 (graph metrics), 7.1-7.2 (wave history), 4.1-4.4 (query processor logging/retry). Each node linked to its target file; constraints include preserving existing code style, ensuring no import breakage, and maintaining backward compatibility with default values.

**Relax / Tension detected**
Tension ~0.15 — minor conflict between the `prune()` signature change (default param was `0.25` positional, now `None` with settings lookup) and existing callers that may pass explicit thresholds. Resolved by making `threshold` optional (`None` triggers config lookup), so explicit callers still work unchanged. No other constraint violations detected.

**Break** (if applicable)
Orphaned `edge.py` node collapsed — `GraphEdge` dataclass was never imported anywhere; `Edge` from `core/types.py` is the canonical type. File deleted.

**Evolve**
Higher-stability configuration emerged:
- `universal_living_graph.py`: 4 wave parameters now configurable via `_wave_settings`, JSON validation guard on `load()`, new `get_metrics()` method, proper `logging` module added.
- `wave.py`: Module-level `_wave_history` deque (maxlen=100) with `get_wave_history()` accessor; `run_wave()` appends snapshot each cycle.
- `query_processor.py`: All `print()` replaced with `logger.info/warning`, sufficiency weights pulled from `synthesis_config`, LLM synthesis wrapped in 2-attempt retry loop with logged exceptions.

**Final stable configuration / Answer**
All six sub-tasks implemented:
1. **2.2** — `spread_factor`, `relax_decay`, `tension_threshold`, `prune_threshold` added as defaults in `_resolve_wave_settings`; `propagate()`, `relax()`, `detect_tensions()`, `prune()` all read from `_wave_settings`.
2. **2.3** — `core/graph/edge.py` deleted; `__init__.py` already had no `GraphEdge` import.
3. **2.4** — `load()` validates `raw` is a dict with `"nodes"` key before clearing state.
4. **2.5** — `get_metrics()` returns total/active/collapsed nodes, edges, avg activation/stability, topic counts, edge density.
5. **7.1-7.2** — `wave.py` gains `_wave_history` deque and `get_wave_history()`; `run_wave()` records strongest, tension_count, total_tension, collapsed, evolved_count per cycle.
6. **4.1-4.4** — `query_processor.py` uses `logging` throughout, sufficiency weights are configurable via `synthesis_config`, LLM call has 2-attempt retry with per-attempt warning logs.
