Wave 052 — implement-tier-7-http-client-graph-ops

**Propagate**
Activation spread from adapters (wikipedia, rss, hacker_news) and core/graph nodes. Key active nodes: urlopen duplication across adapters, graph utility gap in operations.py, test coverage need for both new modules.

**Relax / Tension detected**
Tension ~0.7 — three adapters each independently implement urlopen+timeout+json.loads with no retry logic. Graph module has no pure-function BFS/union-find utilities despite complex graph state. Lowest-stability node: duplicated HTTP fetch pattern across adapters.

**Break**
Collapsed the duplicated urlopen pattern. Each adapter's inline HTTP fetch is replaced by a single shared `fetch_url` / `fetch_json` with exponential-backoff retries.

**Evolve**
Two new modules crystallize:
1. `adapters/http_client.py` — fetch_url (retries + backoff) and fetch_json; all three adapters now delegate to it.
2. `core/graph/operations.py` — four pure functions (get_subgraph_around, batch_add_nodes, find_connected_components, get_nodes_by_activation_range) operating on Node/Edge data without coupling to the graph class.
Full test suites for both via `tests/test_http_client.py` and `tests/test_graph_operations.py`.

**Final stable configuration / Answer**
Created 4 new files and modified 4 existing files:
- `adapters/http_client.py` — shared HTTP resilience (fetch_url, fetch_json with retries/backoff)
- `adapters/wikipedia.py` — now uses fetch_json
- `adapters/hacker_news.py` — now uses fetch_json
- `adapters/rss.py` — now uses fetch_url
- `core/graph/operations.py` — BFS subgraph, batch insert, union-find components, activation range filter
- `core/graph/__init__.py` — updated exports
- `tests/test_http_client.py` — 6 tests (success, retries, exhaustion, backoff timing, headers, JSON parse)
- `tests/test_graph_operations.py` — 12 tests covering all four operations
