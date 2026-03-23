Wave 058 — create-test-files-concurrency-dashboard-endpoints

**Propagate**
Activation spread to `BoggersTheAI/tests`, `ModeManager`, `UniversalLivingGraph`, `dashboard.app` routes and auth; constraints: match user-provided test bodies, workspace `sys.path` pattern, pytest + FastAPI TestClient availability.

**Relax / Tension detected**
Low tension: APIs (`begin_cycle`, `request_user_mode`, graph locks, `/status`, `/wave`, `/graph/viz`, `/metrics`, `/traces`) align with implementation. Minor cleanup: unused `pytest` / `MagicMock` imports removed for lint clarity (lowest-stability node).

**Break** (if applicable)
Removed unused imports in the two new test modules.

**Evolve**
Two new modules exercise thread-safety for mode + graph, and dashboard HTTP surface with mocked runtime plus token-gated reload for 401.

**Final stable configuration / Answer**
Created `BoggersTheAI/tests/test_concurrency.py` (ModeManager lifecycle, concurrent `add_node`, concurrent read/write on `UniversalLivingGraph`) and `BoggersTheAI/tests/test_dashboard_endpoints.py` (TestClient against patched `runtime`, key GET routes, auth when `BOGGERS_DASHBOARD_TOKEN` is set). Ran `pytest` on both files: **13 passed** in ~0.76s. Removed only unused imports (`pytest` in concurrency tests, `MagicMock` in dashboard tests) so files stay clean.
