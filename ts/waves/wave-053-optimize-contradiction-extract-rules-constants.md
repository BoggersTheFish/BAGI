Wave 053 — optimize-contradiction-extract-rules-constants

**Propagate**
User request: replace `detect_contradictions` with topic-indexed pre-filtering in `BoggersTheAI/core/contradiction.py`; add module constants and wire defaults in `BoggersTheAI/core/graph/rules_engine.py`. Workspace: BoggersTheAI.

**Relax / Tension detected**
None; instructions are explicit and complete.

**Break**
N/A

**Evolve**
Implement exact replacements; ensure `Set` import suffices for `checked: Set[tuple[str, str]]`; write wave 053 and bump `CURRENT-WAVE.txt` to 054.

**Final stable configuration / Answer**
`core/contradiction.py`: `detect_contradictions` now builds `topic_to_ids` / `active_map`, iterates co-active pairs per topic with `checked` dedup, then applies the same overlap/antonym/severity logic. `core/graph/rules_engine.py`: module constants after `logger`; `prune_edges`, `spawn_emergence`, `merge_similar_topics`, `split_overactivated` (default `activation_cap` only per spec), `reward_novelty` defaults updated; `SPLIT_ACTIVATION_FACTOR` / `SPLIT_STABILITY_FACTOR` defined as requested (split body literals unchanged). `CURRENT-WAVE.txt` advanced to 054.
