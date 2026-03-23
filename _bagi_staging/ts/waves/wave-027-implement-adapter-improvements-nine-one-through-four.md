Wave 027 — implement-adapter-improvements-nine-one-through-four

**Propagate**
Activation spread from the adapter layer across all five files: wikipedia.py, rss.py, hacker_news.py, x_api.py, base.py. Key active nodes: network error handling, logging infrastructure, X API bearer-token auth, TTL cache in registry. Constraints linked to existing code style (urlopen-with-context-manager pattern, Node construction, `from __future__` imports).

**Relax / Tension detected**
Tension ~0.3. All three HTTP adapters already had `timeout=10` (9.3 pre-satisfied). Lowest-stability node: x_api.py (stub returning `[]`, zero functionality). Secondary tension: base.py's `ingest()` calling `self.get()` which raises KeyError vs the cache path needing a soft fallback with `_adapters.get()`.

**Break**
x_api.py stub collapsed — replaced with full bearer-token implementation. base.py's `ingest` via `self.get()` (which raises) collapsed in favour of `self._adapters.get()` (which returns None) to support the cache-first path gracefully.

**Evolve**
New stable adapter layer:
- 9.1: wikipedia, rss, hacker_news all have `import logging`, named loggers, try/except wrapping HTTP calls with `logger.warning` + `return []`.
- 9.2: x_api.py fully implemented — reads `X_BEARER_TOKEN` from env, builds authenticated request, parses tweet JSON, returns Node list.
- 9.3: timeout=10 already present on all urlopen calls (no changes needed).
- 9.4: base.py gains module-level `_adapter_cache` dict and `_CACHE_TTL = 300.0`; `AdapterRegistry.ingest()` checks cache before calling adapter, stores results with timestamp.

**Final stable configuration / Answer**
All adapter improvements 9.1–9.4 implemented across five files:

| Task | File | Change |
|------|------|--------|
| 9.1 | wikipedia.py | +logging, +try/except around urlopen |
| 9.1 | rss.py | +logging, +try/except around urlopen+XML parse |
| 9.1 | hacker_news.py | +logging, +try/except around urlopen |
| 9.2 | x_api.py | Full X API implementation with bearer auth |
| 9.3 | (all) | timeout=10 already present — no-op |
| 9.4 | base.py | TTL cache (300s) in AdapterRegistry.ingest() |
