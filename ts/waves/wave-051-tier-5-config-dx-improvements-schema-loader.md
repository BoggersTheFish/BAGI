Wave 051 — tier-5-config-dx-improvements-schema-loader

**Propagate**
Activation: `config_schema` (ranges, required sections, strict + `BOGGERS_CONFIG_STRICT`), `config_loader` runtime keys → `RuntimeConfig`, `RuntimeConfig` new fields, `pyproject.toml` pytest, `.pre-commit-config.yaml`, `Makefile`, tests.

**Relax / Tension detected**
`wave.spread_factor` was already ranged; added `guardrails.high_tension_pause`, `wave.relax_decay`. Required-section tests expanded for `os_loop`, `autonomous`, `embeddings`.

**Break** (if applicable)
N/A.

**Evolve**
Single source of truth for strict validation via parameter + env; backend paths on `RuntimeConfig` for typed access alongside `raw_config`.

**Final stable configuration / Answer**
Tier 5 is implemented under `BoggersTheAI/`:

1. **`core/config_schema.py`** — Range checks for `guardrails.high_tension_pause`, `wave.relax_decay`, and existing `wave.spread_factor` (0–1). `_REQUIRED_SECTIONS` includes `os_loop`, `autonomous`, `embeddings`. `validate_config(raw, strict=False)` raises `ValueError` with newline-joined warnings when `strict` is True or `BOGGERS_CONFIG_STRICT` is `1`/`true`.

2. **`core/config_loader.py` + `interface/runtime.py`** — `RuntimeConfig` gains `graph_backend`, `sqlite_path`, `snapshot_dir` (optional); `apply_yaml_to_config` maps them from `runtime:` in YAML.

3. **`pyproject.toml`** — `[tool.pytest.ini_options]` with `testpaths`, `addopts`, `markers`.

4. **`BoggersTheAI/.pre-commit-config.yaml`** — ruff (fix), black, isort as specified.

5. **`BoggersTheAI/Makefile`** — `install`, `test`, `lint`, `format`, `run`, `dashboard` targets as specified.

6. **`tests/test_config_schema.py`** — Valid fixture includes new sections; `test_missing_sections` checks all five; tests for `strict=True` and env-driven strict mode.

Full test suite passes (`pytest -q`).
