Wave 050 — add-threading-lock-hypothesis-queue-context-mind-reads

**Propagate**
Activation spread from router queue concurrency, ContextManager read consistency, and exact user patch constraints into `router.py` and `context_mind.py`.

**Relax / Tension detected**
Low tension: edits match the requested diffs; `process_text` still uses `_enqueue_hypotheses` under the new lock. Estimated tension ~0.1; lowest-stability node was verifying lints after structural lock changes.

**Break**
N/A — no conflicting pattern required collapsing.

**Evolve**
Hypothesis deque is guarded by `threading.Lock` for append, popleft, and enqueue; `ContextMind` no longer carries an unused per-instance lock; `ContextManager.get`, `get_or_default`, and `list_contexts` read under `self._lock`.

**Final stable configuration / Answer**
Implemented in `BoggersTheAI/core/router.py`: `import threading`, `self._queue_lock`, wrapped autonomous-cycle queue appends and the dequeue loop (check-empty inside lock, process outside), and `with self._queue_lock` in `_enqueue_hypotheses`. In `BoggersTheAI/core/context_mind.py`: removed `ContextMind._lock`; wrapped `get`, `get_or_default`, and `list_contexts` with `with self._lock`. `get_subgraph_view` unchanged aside from inheriting locked `get_or_default`.
