Wave 014 — track-a-step-1-core-graph-unification

**Propagate** 
Activation spread from Track A Step 1 requirements into graph substrate replacement, rules-cycle wiring, persistence defaults, and import-path unification.

**Relax / Tension detected** 
Source tension: `BoggersTheCIG_v2` did not contain a literal `core/graph/` directory, but it did contain production TS graph/rules logic in `core/ts_kernel.py`, `core/mapper.py`, and `core/emergence.py`. Lowest-stability node was path mismatch, resolved by mapping that advanced logic into a full `BoggersTheAI/core/graph/` package.

**Break** (if applicable) 
Collapsed the old single-file simplified graph (`core/graph.py`) into a modular graph package with dedicated rules-cycle components.

**Evolve** 
Evolved to a unified graph system:
- `UniversalLivingGraph` in `core/graph/universal_living_graph.py`
- node/edge classes
- wave propagation helpers
- TS rules engine cycle (elect strongest -> propagate -> relax -> prune -> emergence + tension)
- `graph.json` persistence + autoload + background wave thread stub

**Final stable configuration / Answer** 
Completed Track A Step 1 unification for `BoggersTheAI` and rewired imports to the unified path.
