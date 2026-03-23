Wave 044 — make-exact-changes-boggers-ai-five-files

**Propagate**
User requested exact edits across BoggersTheAI: embeddings constant removal, types alias removal, router language simplification, adapter time import cleanup, pyproject ruff/entry-points.

**Relax / Tension detected**
Constraint: all replacements must match file contents exactly; initial embeddings patch had a typo. Low tension after correction.

**Break** (if applicable)
Initial fuzzy match on `_EMBED_DIM` — corrected to exact `_EMBED_DIM`.

**Evolve**
Applied five targeted edits; verified `GraphState` had no remaining references.

**Final stable configuration / Answer**
Completed: removed `_EMBED_DIM` from `core/embeddings.py`; removed `GraphState` from `core/types.py` (kept `Dict` for `Node.attributes`); `_detect_language` in `tools/router.py` now always returns `"python"`; removed inner `import time as _time` in `adapters/base.py` and use module `time.time()`; updated `pyproject.toml` with `[project.entry-points."boggers.adapters"]`, `[project.entry-points."boggers.tools"]`, `[tool.ruff]`, `[tool.ruff.lint]`, before existing isort/black. `CURRENT-WAVE.txt` incremented to 045.
