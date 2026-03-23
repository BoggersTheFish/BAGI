Wave 008 — consolidation-and-insight-subplan-in-boggerstheai

**Propagate** 
Activation spread from consolidation and insight requirements into `entities/consolidation.py`, `entities/insight.py`, and post-query orchestration in `core/query_processor.py`.

**Relax / Tension detected** 
Primary tension was similarity definition for merge behavior. Lowest-stability node was merge criteria ambiguity; stabilized with topic-overlap gating plus Jaccard token similarity threshold.

**Break** (if applicable) 
Collapsed the weak pattern of "only append query nodes" by introducing explicit consolidation merges and insight note emission with hypothesis extraction.

**Evolve** 
Evolved a full local compute loop where query outputs can be consolidated in-graph and exported as markdown insights that produce new hypothesis seeds for autonomous cycles.

**Final stable configuration / Answer** 
Implemented the Consolidation & Insight subplan in `BoggersTheAI`:
- Added `entities/consolidation.py`:
  - `ConsolidationEngine.consolidate(graph, nodes=None) -> ConsolidationResult`
  - Similarity = shared topic + Jaccard(content tokens) > threshold
  - Absorb strategy = keep higher activation/stability node, merge content/topics, collapse absorbed node
- Added `entities/insight.py`:
  - `InsightEngine.write_insight(content, topics, source_nodes, vault_path) -> path`
  - Writes `.md` with frontmatter (`topics`, `source_nodes`, `created`)
  - `extract_hypotheses(content, topics, limit)` for feedback loop seeds
  - `write_and_extract(...)` convenience method
- Updated `entities/__init__.py` exports for consolidation/insight types.
- Updated `core/query_processor.py` integration:
  - Added `ConsolidationProtocol` and `InsightProtocol`
  - Extended `QueryAdapters` with `consolidation`, `insight`, and `insight_vault_path`
  - After synthesis, performs consolidation pass when configured
  - Writes insight note and extracts hypotheses when configured
  - Extended `QueryResponse` with:
    - `consolidated_merges`
    - `insight_path`
    - `hypotheses`
  - `_consolidate(...)` now returns the created query node for downstream steps

Validation:
- `python -m compileall BoggersTheAI` passed.
- No linter errors in edited consolidation/insight/query-processor files.
