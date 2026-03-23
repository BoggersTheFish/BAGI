Wave 056 — config-yaml-pyproject-optional-deps

**Propagate**
Activation: BoggersTheAI config and packaging; user requested precise YAML keys and pyproject optional groups; embeddings left as `nomic-embed-text`; local_llm skipped per user.

**Relax / Tension detected**
Low tension: `synthesis` already existed under `inference:`; added only `max_retries` and `backup_dir` as specified.

**Break**
N/A

**Evolve**
`config.yaml` now has `fine_tuning.backup_dir` and `inference.synthesis.max_retries`; `pyproject.toml` gains `multimodal` and `adapters` optional dependency groups after `all`.

**Final stable configuration / Answer**
Edits applied in `BoggersTheAI/config.yaml`: after `safety_dry_run: true` added `backup_dir: "models/backups"` under `fine_tuning`; under existing `inference.synthesis` added `max_retries: 2` (with `use_graph_subgraph: true` and `top_k_nodes: 5` unchanged). `embeddings.model` remains `"nomic-embed-text"`. In `BoggersTheAI/pyproject.toml`, after the `all` group, added `multimodal` (faster-whisper, transformers, pillow, piper-tts) and `adapters` (feedparser) optional groups. Items 1 and 2 only; no `local_llm.py` changes.
