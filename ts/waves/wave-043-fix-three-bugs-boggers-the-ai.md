Wave 043 — fix-three-bugs-boggers-the-ai

**Propagate**
Activation: BoggersTheAI `calc.py` ops dict, `vault.py` ingest path resolution, `query_processor.py` inference fallback tuple shape, `runtime.py` Vault wiring, tests.

**Relax / Tension detected**
Tension: topic strings were passed to MarkdownAdapter as bogus paths; inference fallback needed explicit tuple + confidence 0.0 per spec; calc missing `%` and `//`.

**Break** (if applicable)
Weak pattern: VaultAdapter() without config and blind `ingest(source)` forwarding.

**Evolve**
Added `ast.Mod` / `ast.FloorDiv`; VaultAdapter resolves `runtime.insight_vault_path`, joins relative sources to vault root, uses vault root for absolute `source`; inference path returns `(answer, [], 0.0, "inference_router_fallback")`; runtime passes `raw_config`; test uses relative `note.md` under tmp vault.

**Final stable configuration / Answer**
- `tools/calc.py`: `_ops` includes `ast.Mod` → `operator.mod`, `ast.FloorDiv` → `operator.floordiv` after `ast.Div`.
- `adapters/vault.py`: `__init__(config)` reads `runtime.insight_vault_path` (default `./vault`), `ingest` resolves path per spec, delegates to `MarkdownAdapter`.
- `core/query_processor.py`: inference fallback returns the same 4-tuple with `confidence=0.0`.
- `interface/runtime.py`: `VaultAdapter(self.raw_config)` so loaded YAML applies.
- `tests/test_adapters_detailed.py`: vault test uses config + relative filename.
