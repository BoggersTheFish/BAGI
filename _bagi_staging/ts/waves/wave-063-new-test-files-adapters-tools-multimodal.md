Wave 063 — new-test-files-adapters-tools-multimodal

**Propagate**
User requested three new pytest modules under `BoggersTheAI/tests` with verbatim bodies; activation: adapters (mocked HTTP, registry), tools (router/executor), multimodal (voice/image).

**Relax / Tension detected**
Tension: Wikipedia snippet mocked `query.search` but `WikipediaAdapter` uses `query.pages` + `extracts`; `ImageInAdapter` default `blip2` loads huge models and hung tests. Relaxed by aligning mocks with `adapters/wikipedia.py` and using `ImageInConfig(backend="placeholder")` for the caption test.

**Break**
N/A — adjusted tests to match implementation, not production code.

**Evolve**
All 26 tests pass in ~0.16s; `pytest` on the three files is green.

**Final stable configuration / Answer**
Created `tests/test_adapters_detailed.py`, `tests/test_tools_detailed.py`, and `tests/test_multimodal.py`. Two small deviations from the pasted snippets: Wikipedia success mock uses `query.pages` with `title`/`extract` to match the real API; image caption test uses `ImageInConfig(backend="placeholder")` so CI does not download or run BLIP2. Run: `pytest BoggersTheAI/tests/test_adapters_detailed.py BoggersTheAI/tests/test_tools_detailed.py BoggersTheAI/tests/test_multimodal.py`.
