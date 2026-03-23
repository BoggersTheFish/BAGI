Wave 027 — implement-interface-runtime-dashboard-improvements

**Propagate**
Activation spread across runtime.py (print→logging, config_loader wiring, adapter flags), api.py (singleton pattern), chat.py (error handling), and dashboard/app.py (auth, configurable host/port, /graph, /traces endpoints). Eight distinct change nodes all converging on the interface+dashboard layer.

**Relax / Tension detected**
Tension ~0.35 — mild. Primary constraint: print() calls using emoji cause UnicodeEncodeError on Windows cp1252. Secondary: per-call BoggersRuntime instantiation in api.py wastes resources. Tertiary: dashboard lacks auth, introspection endpoints, and configurability.

**Break**
Collapsed: raw print() pattern in runtime.py, naive per-call runtime creation in api.py, hardcoded dashboard host/port.

**Evolve**
New stable structure: logging module replaces all print() (no emoji, Windows-safe), module-level singleton in api.py, try/except in chat.py, config_loader wired into __init__ with adapter enable flags, dashboard gains token auth middleware, env-configurable host/port, /graph and /traces endpoints.

**Final stable configuration / Answer**
All 8 improvements implemented across 4 files:

- **12.1** `runtime.py`: Added `import logging` + `logger = logging.getLogger("boggers.runtime")`. All 6 print() calls replaced with `logger.info(...)` using `%`-style formatting, no emoji.
- **12.3** `api.py`: Rewritten with `_shared_runtime` singleton via `get_runtime()`, try/except around `rt.ask()`, logger for errors.
- **12.4** `chat.py`: `rt.ask(query)` wrapped in try/except, prints `Error: {exc}` on failure.
- **12.5** `runtime.py __init__`: `load_and_apply` called right after config init; adapter registration now checks `self.raw_config["adapters"]["enabled"]` flags with sensible defaults.
- **13.1** `app.py main()`: Reads `BOGGERS_DASHBOARD_HOST` / `BOGGERS_DASHBOARD_PORT` from env.
- **13.3** `app.py`: `_check_auth` dependency using `BOGGERS_DASHBOARD_TOKEN` env var; applied to `/status`, `/graph`, `/traces`. `/wave` stays public.
- **13.4** `app.py`: `/graph` endpoint returns all nodes (id, topics, activation, stability, collapsed) and edges (src, dst, weight).
- **13.5** `app.py`: `/traces` endpoint returns latest N trace files from `traces/` dir.

Zero print() calls remain in runtime.py. No linter errors introduced.
