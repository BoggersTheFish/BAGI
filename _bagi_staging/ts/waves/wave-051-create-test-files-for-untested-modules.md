Wave 051 — create-test-files-for-untested-modules

**Propagate**
Activation spread from user request across 7 source modules: config_loader, plugins, sqlite_backend, rules_engine, inference_router, path_sandbox, wave_runner. Each module's API surface, dependency chain, and dataclass shapes activated as constraint nodes. Existing conftest.py sys.path pattern propagated as structural template.

**Relax / Tension detected**
Tension ~0.15 — low. Minor constraint: wave_runner.run_single_cycle deeply couples to UniversalLivingGraph internals (private methods), requiring MagicMock. path_sandbox test for absolute-outside-base needed careful path construction to trigger traversal on Windows. All lines must stay ≤88 chars (ruff E501).

**Break** (if applicable)
No weak nodes collapsed — all modules had clean, testable public APIs.

**Evolve**
Spawned 7 new test files (33 total test functions) covering every requested module. Each test file: reads source first, uses conftest sys.path pattern, stays ≤88 chars per line, uses tmp_path/MagicMock for isolation.

**Final stable configuration / Answer**
All 7 test files created and **33/33 tests pass** in 0.52s:

| File | Tests | Coverage |
|---|---|---|
| test_config_loader.py | 5 | load_yaml, apply_yaml, deep_merge, load_and_apply, missing file |
| test_plugins.py | 5 | register/get, missing key, names, discover_entry_points, bad module |
| test_sqlite_backend.py | 5 | node roundtrip, edges, meta KV, import/export JSON, node_count |
| test_rules_engine.py | 5 | prune_edges, detect_tension, spawn_emergence, merge_similar, run_rules_cycle |
| test_inference_router.py | 5 | throttle defaults, custom interval, route result, throttle block, fallback |
| test_path_sandbox.py | 3 | valid resolve, .. traversal raises, absolute outside raises |
| test_wave_runner.py | 5 | config defaults, custom config, start/stop, single cycle dict, guardrail skip |
