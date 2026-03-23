Wave 036 — implement-all-improvements-modularly

**Propagate**
Activation spread across every subsystem: types (embedding field), wave_propagation (damping, cap, semantic channel), rules_engine (LLM evolve, contradiction), universal_living_graph (SQLite default, guardrails, snapshots, export, N-wave save), wave.py (rules integration), code_run (sandbox), local_llm (evolve + embed), new modules (embeddings, contradiction, temperament, context_mind, snapshots, export). Config, README, pyproject, dashboard, tests all updated.

**Relax / Tension detected**
Tension: 19 distinct feature requests across 4 timeframes. Lowest-stability node: code_run sandbox (runtime import hooking tricky). Resolved via default-arg closure capture.

**Break**
Collapsed monolithic dependency list into optional extras (llm, gpu, dev, all). Collapsed fine-tuning-on-by-default into off-by-default with mandatory validation.

**Evolve**
Emerged: 7 new modules, 43 new tests (83 total), Cytoscape.js viz, Mermaid README diagram, cognitive temperament system, full contradiction engine, snapshot versioning, GraphML/JSON-LD export, context minds, sandboxed code execution.

**Final stable configuration / Answer**
All 19 requested improvements implemented modularly across v0.3.0. 83 tests pass. All linters clean. Ready for push.
