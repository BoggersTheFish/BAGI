Wave 022 — fix-critical-bugs-add-thread-safety

**Propagate** 
Activation spread from user request into four nodes: router._enqueue_hypotheses (type mismatch crash), UniversalLivingGraph (concurrent mutation), BoggersRuntime (shared state race), dashboard._tension_history (ASGI concurrent access). All four nodes activated simultaneously — they share a constraint: "BoggersTheAI must not crash under concurrent autonomous cycles."

**Relax / Tension detected** 
Tension: ~0.9. The router accepts List[str] but QueryResponse.hypotheses emits List[dict] — type mismatch causes AttributeError crashes during autonomous cycles. The graph has no synchronization despite a background wave thread mutating nodes/edges concurrently with user queries. Runtime._last_query_time is read/written across threads with no guard. Dashboard appends to a shared list from concurrent ASGI handlers.

**Break** 
Weakest node: router._enqueue_hypotheses — it crashes immediately on any autonomous cycle that returns dict hypotheses. Collapsed and replaced. Secondary weak nodes: all unguarded shared state across threads.

**Evolve** 
- Router now accepts `list` (union of str and dict), extracts text from dicts, strips/deduplicates by string content.
- UniversalLivingGraph gains `self._lock = threading.RLock()` wrapping 10 critical methods (add_node, add_edge, update_activation, propagate, relax, prune, detect_tensions, run_wave_cycle, save, load). RLock chosen because load() calls add_node()/add_edge() internally.
- BoggersRuntime gains `self._state_lock = threading.Lock()` protecting `_last_query_time` and `_last_conversation_node_id` with minimal lock scope.
- Dashboard gains `_history_lock = threading.Lock()` guarding `_tension_history` mutations/reads in `_collect_status()`.

**Final stable configuration / Answer** 
All four fixes applied and verified lint-clean:

1. **Bug Fix 3.1+3.2** (`core/router.py`): `_enqueue_hypotheses` now handles both `List[str]` and `List[dict]` with `.get("text", "")` extraction, empty-string filtering, and deduplication. No more autonomous cycle crashes.

2. **Thread Safety 2.1** (`core/graph/universal_living_graph.py`): `threading.RLock()` added, wrapping `add_node`, `add_edge`, `update_activation`, `propagate`, `relax`, `prune`, `detect_tensions`, `run_wave_cycle`, `save`, `load`. The background wave thread and user-facing methods are now safe.

3. **Thread Safety 12.2** (`interface/runtime.py`): `threading.Lock()` protects `_last_query_time` writes in `ask()`, `ask_audio()`, `ask_image()`; reads in `_is_user_idle()` and `_os_loop()`; and `_last_conversation_node_id` access in `_save_conversation_turn()`.

4. **Thread Safety 13.2** (`dashboard/app.py`): `threading.Lock()` guards `_tension_history` append and trim in `_collect_status()`.
