Wave 004 — look-at-this-for-more-context-only-subplan

**Propagate** 
Activation spread from the synthesis subplan into `InferenceProtocol`, `QueryProcessor` synthesis boundary, and `entities` inference implementation.

**Relax / Tension detected** 
Constraint tension came from scope drift risk: building the full `boggers-the-ai` plan versus implementing only the synthesis subplan. Lowest-stability node was "inference boundary shape" between `core` and `entities`.

**Break** (if applicable) 
Collapsed the weak pattern of generic LLM-style context objects as synthesis input and replaced it with a strict string-context synthesis contract.

**Evolve** 
Evolved to a dedicated single-job synthesis component in `entities/synthesis_engine.py` and a query processor that renders retrieved graph nodes into compact grounded context text.

**Final stable configuration / Answer** 
Implemented only the synthesis subplan in `BoggersTheAI`:
- Added `entities/synthesis_engine.py` with `BoggersSynthesisEngine.synthesize(context: str, query: str) -> str`.
- Added `entities/__init__.py` exports.
- Updated `core/query_processor.py`:
  - `InferenceProtocol` now uses `synthesize(context: str, query: str) -> str`.
  - Added `_render_context_text()` to convert retrieved nodes into synthesis input.
  - Updated fallback synthesis response to be explicitly context-grounded.
  - Replaced unstable `hash()`-based node IDs with deterministic SHA1-based IDs.

Validation:
- `python -m compileall BoggersTheAI` passed.
- No linter errors in edited files.
