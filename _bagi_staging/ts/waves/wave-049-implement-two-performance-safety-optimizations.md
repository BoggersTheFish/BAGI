Wave 049 — implement-two-performance-safety-optimizations

**Propagate**
Activation spread from adapter cache concurrency, graph guardrail races, and StrReplace edits across `adapters/base.py` and `core/graph/universal_living_graph.py`.

**Relax / Tension detected**
Prior tension: module-level dicts mutated without synchronization; `_check_guardrails` read `self.nodes`, hour/cycle state, and `_last_tension` without `self._lock`. Estimated tension: moderate. Lowest-stability node: unchecked shared mutable state under multi-threaded ingest and background wave.

**Break**
Assumption that dict reads/writes are “atomic enough” without explicit locking for rate-limit + cache coherence.

**Evolve**
Added `_cache_lock` and wrapped all `_adapter_cache` / `_adapter_call_counts` access in `AdapterRegistry.ingest` (releasing lock before `adapter.ingest`). Wrapped `_check_guardrails` body in `with self._lock:` so node counts, hour rollover, cycle count, and tension snapshot are consistent with other graph mutations.

**Final stable configuration / Answer**
1. **`BoggersTheAI/adapters/base.py`**: `import threading`, module `_cache_lock = threading.Lock()`, first `with _cache_lock:` covers cache get, call-count bump, rate-limit branch, and adapter lookup; second `with _cache_lock:` stores the cache entry after `adapter.ingest` returns.  
2. **`BoggersTheAI/core/graph/universal_living_graph.py`**: `_check_guardrails` now performs active node count, hour reset, `_cycles_this_hour` check, and `_last_tension` check entirely under `self._lock`; no I/O in that block so lock duration stays short.
