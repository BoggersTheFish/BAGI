Wave 032 — implement-testing-ci-onboarding-nice-to-haves

**Propagate** 
Activation spread from user request across: test coverage nodes (test_wave, test_graph, test_query_processor), demo/examples nodes (autonomous_demo, graph_evolution_demo), multimodal feedback node (ask_image → graph node injection), adapter throttling node (rate limiting in AdapterRegistry), and onboarding node (good_first_issue template). All six task nodes activated in parallel.

**Relax / Tension detected** 
Tension ~0.3 — mild constraint: the adapter `base.py` used `logger` without importing it; runtime `ask_image` needed `time` import already present at module level. Both resolved during implementation. Test style needed to match existing `from BoggersTheAI.*` imports and `auto_load=False` pattern — confirmed from `test_wave.py` and `test_graph.py`.

**Break** (if applicable) 
No weak nodes collapsed — all six tasks were well-defined and independently implementable.

**Evolve** 
Higher-stability configuration achieved:
- 3 new detailed test files (test_wave_detailed, test_graph_detailed, test_query_processor_detailed) covering propagation, relaxation, breaking, evolution, topic indexing, pruning, tension detection, metrics, incremental save, topic extraction, sufficiency scoring, and context retrieval
- 2 demo scripts (autonomous_demo, graph_evolution_demo) showing real runtime usage patterns
- Multimodal feedback: ask_image now persists captions as graph nodes with topics=["image","caption","multimodal"]
- Adapter throttling: per-adapter per-minute call counter with _MAX_CALLS_PER_MINUTE=30
- Good first issue GitHub template for onboarding contributors

**Final stable configuration / Answer** 
All changes implemented:

**6A — Tests** (3 files created):
- `tests/test_wave_detailed.py` — 5 tests: propagate spreads activation, relax produces tensions, break_weakest collapses node, evolve creates child, run_wave full cycle
- `tests/test_graph_detailed.py` — 6 tests: topic index, propagate+relax, prune removes weak edges, detect tensions, get_metrics, incremental save
- `tests/test_query_processor_detailed.py` — 3 tests: topic extraction, sufficiency score empty, context retrieval

**3A — Demo scripts** (2 files created):
- `examples/autonomous_demo.py` — seeds knowledge, runs 60s autonomous with wave+OS-loop
- `examples/graph_evolution_demo.py` — injects nodes, runs 5 wave cycles, shows evolution

**7A — Multimodal graph feedback**: `runtime.py` `ask_image()` now stores captions as graph nodes

**7B — Adapter throttling**: `adapters/base.py` gains `_adapter_call_counts` + 30/min rate limit per adapter

**7C — Good first issue template**: `.github/ISSUE_TEMPLATE/good_first_issue.yml` created
