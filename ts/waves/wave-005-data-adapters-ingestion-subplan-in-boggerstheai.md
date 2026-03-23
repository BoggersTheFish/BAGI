Wave 005 — data-adapters-ingestion-subplan-in-boggerstheai

**Propagate** 
Activation spread from ingestion contracts and phase priorities into `adapters/base.py`, zero-auth adapters, and adapter configuration nodes.

**Relax / Tension detected** 
Primary tension was balancing "complete catalog" vs "implement now." Lowest-stability node was adapter scope breadth; resolved by implementing Phase 1 concrete adapters while preserving extension points for later phases.

**Break** (if applicable) 
Broke the weak pattern of empty/stub adapter files by replacing them with protocol-driven, executable ingestion adapters.

**Evolve** 
Evolved a stable ingestion layer with a universal `IngestProtocol`, registry orchestration, and concrete adapters for web and local markdown/vault sources.

**Final stable configuration / Answer** 
Implemented the Data Adapters ingestion subplan in `BoggersTheAI/adapters`:
- Added `base.py` with `IngestProtocol` and `AdapterRegistry`.
- Implemented `wikipedia.py` (MediaWiki API, one-shot ingest).
- Implemented `rss.py` (RSS/Atom parsing with stdlib XML).
- Added `hacker_news.py` (Algolia API ingestion).
- Added `markdown.py` (single file or directory recursive markdown ingestion, section chunking).
- Implemented `vault.py` as markdown-vault ingestion wrapper.
- Implemented `x_api.py` as explicit deferred phase adapter (returns empty until auth integration).
- Updated `adapters/__init__.py` exports.
- Added `adapters/config.yaml` with enabled adapters, sources, and poll intervals.

Validation:
- `python -m compileall BoggersTheAI` passed.
- No linter errors in edited adapter files.
