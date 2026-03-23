Wave 003 — follow-this-plan-in-boggerstheai

**Propagate** 
Activation spread from the core plan into implementation nodes: `graph.py`, `wave.py`, `mode_manager.py`, `query_processor.py`, and protocol boundaries in `types`/`__init__`.

**Relax / Tension detected** 
Primary tension was boundary clarity between Core and adapters. Tension estimate was medium; lowest-stability node was "query orchestration ownership."

**Break** (if applicable) 
Broke the weak pattern of mixing external logic into core by enforcing adapter protocols and keeping core modules I/O-light.

**Evolve** 
Evolved into a stable package design with deterministic wave functions, thread-safe mode handoff, topic-indexed graph retrieval, and a query pipeline that delegates research/synthesis through interfaces.

**Final stable configuration / Answer** 
Implemented the plan in `BoggersTheAI/core` with:
- `graph.py`: `UniversalLivingGraph` supporting node/edge operations, topic indexing, activation updates, and JSON save/load.
- `wave.py`: Propagate/Relax/Break/Evolve functions plus `run_wave()` returning `WaveResult`.
- `mode_manager.py`: AUTO/USER state handoff with safe cycle boundaries.
- `query_processor.py`: protocols (`GraphProtocol`, `InferenceProtocol`, `IngestProtocol`, `ToolProtocol`) and `QueryProcessor.process_query()`.
- `types.py`: `Node`, `Edge`, `Tension` dataclasses.
- package exports in `core/__init__.py`.

Validation: `python -m compileall BoggersTheAI` completed successfully and no linter errors were reported for edited files.
