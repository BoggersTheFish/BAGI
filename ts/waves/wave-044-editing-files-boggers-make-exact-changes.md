Wave 044 — editing-files-boggers-make-exact-changes

**Propagate** 
Activation spread across BoggersTheAI interface singleton, mode manager wait semantics, and dashboard auth for wave/graph HTML endpoints; constraints: thread safety, no infinite wait, bearer alignment with cookie.

**Relax / Tension detected** 
Prior tension: unguarded lazy singleton, unbounded condition wait, unauthenticated fetches to protected routes. Estimated tension reduced; lowest-stability node was dashboard JS without Authorization header when token is set.

**Break** (if applicable) 
Collapsed the pattern of assuming single-threaded runtime init and unauthenticated embedded dashboard fetches.

**Evolve** 
Double-checked lazy init under lock; timed waits with flag reset on timeout; conditional Bearer headers from `boggers_token` cookie; `graph_viz` uses `Depends(_check_auth)`.

**Final stable configuration / Answer** 
Implemented exactly: `interface/api.py` — `threading.Lock()`, double-checked locking in `get_runtime()`; `core/mode_manager.py` — `request_user_mode(timeout=30.0) -> bool` with `Condition.wait(timeout=deadline)` and `False` on timeout; `dashboard/app.py` — `/wave` and `/graph/viz` JS add optional `Authorization` from cookie; `/graph/viz` route adds `_check_auth` dependency.
