Wave 017 — track-c-step-2-local-llm-hypotheses

**Propagate** 
Activation spread into local synthesis orchestration nodes: query processor synthesis branch, Ollama config gate, and hypothesis payload structure.

**Relax / Tension detected** 
Primary tension was preserving fallback behavior while introducing local LLM + hypothesis outputs. Stabilized by guarded Ollama path and extractive fallback.

**Break** (if applicable) 
Collapsed string-only synthesis output shape into structured outputs with confidence and reasoning trace.

**Evolve** 
Evolved to hybrid synthesis:
- graph-aware context retrieval from Track C Step 1
- optional local LLM synthesis/hypothesis generation
- consistency check pass
- full fallback to existing behavior

**Final stable configuration / Answer** 
Track C Step 2 implemented:
- Added `core/local_llm.py` with `LocalLLM.summarize_and_hypothesize(...)`
- Updated `core/query_processor.py` synthesis flow to use Ollama when enabled
- Added structured response fields: `hypotheses`, `confidence`, `reasoning_trace`
- Wired runtime LLM initialization and QueryProcessor injection
- Added `inference.ollama` config section
- Added `ollama` dependency in `pyproject.toml`
