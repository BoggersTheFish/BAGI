Wave 041 — explore-improvements-optimizations-growth

**Propagate**
Full codebase audit activated across all 106 source files, 30 test files, CI pipeline, config.yaml, and pyproject.toml. Three parallel exploration agents scanned: (1) code quality + architecture + security + performance, (2) test suite + CI pipeline gaps, (3) config trace + feature completeness + new capabilities. Combined findings: 200+ items across 12 categories.

**Relax / Tension detected**
Tension: 0.85 — major gaps identified:
- 8 bugs including mode manager timeout race, calc missing operators, vault path confusion
- 9 security gaps including XML bomb risk, path traversal in markdown adapter, no file size limits
- 17 untested source modules, weak assertions in existing tests
- 15+ config keys defined but never read
- O(n^2) in consolidation and batch cosine matrix
- Runtime.py is 830+ lines doing too much
- No retry on any network adapter
- SQLite connections never closed
- Placeholder multimodal backends return fake strings
- No streaming, no semantic search, no scheduled ingest

Lowest-stability nodes: mode_manager deadline bug, vault adapter path confusion, XML parsing vulnerability, runtime monolith.

**Break**
Collapsed the assumption that the system is production-ready. Multiple layers need hardening before real deployment.

**Evolve**
Organized all findings into 7 execution tiers by TS-logic priority (tension × impact × modularity).

**Final stable configuration / Answer**
See full categorized findings below.
