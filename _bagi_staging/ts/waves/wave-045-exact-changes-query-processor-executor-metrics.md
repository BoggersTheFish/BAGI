Wave 045 — exact-changes-query-processor-executor-metrics

**Propagate**
Activation spread to BoggersTheAI `query_processor.py`, `executor.py`, metrics import paths, `process_query` refactor to `_process_query_inner`, and `synthesis_config.max_retries`.

**Relax / Tension detected**
Constraint: edits must match the user’s exact diff; low tension after applying replacements.

**Break** (if applicable)
N/A — no weak pattern collapsed.

**Evolve**
Stable layout: `process_query` increments `queries_total` and times `query_processing`; body lives in `_process_query_inner`. `_synthesize` reads `max_retries` from config. `ToolExecutor.execute` increments `tool_calls` and times `tool_execution`.

**Final stable configuration / Answer**
Implemented as requested:

1. **`core/query_processor.py`**: Added `from .metrics import metrics`. `process_query` now calls `metrics.increment("queries_total")`, wraps work in `with metrics.timer("query_processing"): return self._process_query_inner(query)`, and the former body is `_process_query_inner`. In `_synthesize`, `max_retries = int(self.synthesis_config.get("max_retries", 2))`.

2. **`tools/executor.py`**: Added `from ..core.metrics import metrics`. `execute` increments `tool_calls` and wraps `self.registry.execute(...)` in `with metrics.timer("tool_execution"):`.

`ts/CURRENT-WAVE.txt` set to 046 for the next interaction.
