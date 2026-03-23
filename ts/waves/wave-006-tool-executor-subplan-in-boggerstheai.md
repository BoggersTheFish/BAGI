Wave 006 — tool-executor-subplan-in-boggerstheai

**Propagate** 
Activation spread from the tool-executor subplan into `tools/base.py`, `tools/router.py`, concrete tool modules, and `core/query_processor.py` integration points.

**Relax / Tension detected** 
Primary tension was tool selection ownership. Lowest-stability node was "LLM chooses tool" versus synthesis-only inference. Resolved by placing selection in a rule-based `ToolRouter` and execution in `ToolExecutor`.

**Break** (if applicable) 
Collapsed empty tool stubs and the ambiguous selection path by implementing explicit router + registry contracts.

**Evolve** 
Evolved to a stable Tool Executor architecture: `ToolRegistry + ToolRouter + pluggable tools`, with Query Processor invoking tools and injecting results back into graph context before synthesis.

**Final stable configuration / Answer** 
Implemented the tool-executor subplan in `BoggersTheAI`:
- Added `tools/base.py` with `ToolProtocol` and `ToolRegistry`.
- Added `tools/router.py` with rule-based `ToolRouter` and `ToolCall`:
  - file read intent
  - code run intent
  - math expression intent
  - explicit search intent
  - sufficiency fallback to search
- Added concrete tools:
  - `tools/search.py` (web research via HN Algolia API)
  - `tools/calc.py` (safe AST arithmetic evaluator)
  - `tools/code_run.py` (sandboxed local python snippet execution with timeout)
  - `tools/file_read.py` (read file content)
- Added `tools/executor.py` (`ToolExecutor` wrapper and default registry wiring).
- Updated `tools/__init__.py` exports and added `tools/config.yaml`.
- Updated `core/query_processor.py`:
  - added `ToolRouterProtocol`
  - extended `QueryAdapters` with `tool_router`
  - runs tool routing/execution when applicable
  - injects tool result as graph node context before synthesis
  - returns `used_tool` and `tool_name` in `QueryResponse`

Validation:
- `python -m compileall BoggersTheAI` passed.
- No linter errors in edited files.
