Wave 045 — implement-two-security-improvements-path-sandbox

**Propagate**
Activation spread from path traversal risk in MarkdownAdapter, reusable sandbox utility, VaultAdapter wiring, and test alignment with relative paths under `base_dir`.

**Relax / Tension detected**
Constraint: tests used absolute paths with default `base_dir="."` — would trip `validate_path`. Resolved by scoping tests to `base_dir=str(tmp_path)` and `ingest("test.md")`. Tension low after test update.

**Break** (if applicable)
Pattern of unvalidated `Path(source)` in `ingest` collapsed in favor of `validate_path` + resolved `Path`.

**Evolve**
`core/path_sandbox.py` centralizes containment checks; `MarkdownAdapter` takes `base_dir`, logs and returns `[]` on blocked traversal; `VaultAdapter` passes `_vault_root` as the sandbox root.

**Final stable configuration / Answer**
Implemented `BoggersTheAI/core/path_sandbox.py` with the specified `validate_path`. Updated `adapters/markdown.py`: `__init__(base_dir=".")`, `validate_path` at start of `ingest`, `ValueError` → `logger.warning` + `[]`. Updated `adapters/vault.py` to `MarkdownAdapter(base_dir=self._vault_root)`. Adjusted `test_adapters_detailed.py` so `MarkdownAdapter` tests use a temp base and relative `"test.md"`. `pytest tests/test_adapters_detailed.py` — 11 passed.
