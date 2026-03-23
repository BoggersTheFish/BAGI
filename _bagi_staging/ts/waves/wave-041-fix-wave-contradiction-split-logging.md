Wave 041 — fix-wave-contradiction-split-logging

**Propagate**
Activation spread through `wave.run_wave`, `relax` contradiction handling, and `rules_engine.split_overactivated` logging semantics; import `detect_contradictions` remains tied to `relax()` only.

**Relax / Tension detected**
Duplicate `detect_contradictions` in `run_wave` after normalisation violated single-detection constraint; split log used post-mutation activation × 2, misreporting pre-split level. Tension low after targeted edits.

**Break** (if applicable)
Redundant second contradiction pass in `run_wave` collapsed; incorrect log expression in `split_overactivated` collapsed.

**Evolve**
`run_wave` appends history without contradiction recount and returns `WaveResult` without `contradictions_found` kwarg (dataclass default applies). `split_overactivated` captures `original_activation` before halving for accurate logging.

**Final stable configuration / Answer**
Edits applied in `BoggersTheAI/core/wave.py`: removed `contradictions = detect_contradictions(...)` and the `"contradictions"` history field; `WaveResult` construction no longer passes `contradictions_found`. Kept `from .contradiction import detect_contradictions, resolve_contradiction` for `relax()`. In `BoggersTheAI/core/graph/rules_engine.py`, `split_overactivated` now sets `original_activation = node.activation` before creating the split node and logs `original_activation` instead of `node.activation * 2` after mutation. Spawn_emergence left unchanged per your note.
