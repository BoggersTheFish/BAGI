Wave 045 — implement-two-security-improvements-rss-file-read

**Propagate**
Activation spread from RSS ingestion (XML parsing hazards), file tool (path/size), pyproject optional-deps graph; nodes: rss.py size cap + SafeET, file_read pinned base + getsize gate, security extras.

**Relax / Tension detected**
Constraints satisfied: 5MB pre-parse cap, defusedxml when installed, FileReadTool max_bytes and resolved base_dir, extensions extended. Tension low.

**Break** (if applicable)
N/A — no weak pattern required collapse.

**Evolve**
Stable layout: optional SafeET at import; runtime branch for parse; FileReadTool uses Path.resolve() for cwd/base at init; execute() stat before read.

**Final stable configuration / Answer**
Implemented both items in `BoggersTheAI`:

1. **`adapters/rss.py`**: `_RSS_XML_MAX_BYTES = 5_000_000`; if `len(raw_xml)` exceeds it, log warning and return `[]`. Try `from defusedxml import ElementTree as SafeET` at module load; use `SafeET.fromstring(raw_xml)` when available, else `ET.fromstring(raw_xml)` after the size check.

2. **`tools/file_read.py`**: `__init__(base_dir, max_bytes=None, config=None)` with `self._max_bytes` from explicit `max_bytes` or `config.get("max_bytes", 1_048_576)`; `base_dir` pinned via `Path(...).resolve()` (or `Path.cwd().resolve()`). In `execute()`, after existence/dir checks, `os.path.getsize(resolved)` vs `self._max_bytes` with a clear error string. `ALLOWED_EXTENSIONS` includes `.toml`, `.cfg`, `.ini`.

3. **`pyproject.toml`**: `[project.optional-dependencies]` entry `security = ["defusedxml"]`.

Tests: `tests/test_tools.py` passes (4 tests).
