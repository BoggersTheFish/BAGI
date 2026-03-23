Wave 033 — major-v03-evolution

**Propagate**
Activation spread across all 7 improvement categories: graph persistence (SQLite, incremental save, pruning, migration), wave mechanics (per-type thresholds, damping, merge/split/novelty rules, telemetry, safety caps), self-improvement (quality gate, multi-model, lineage tracking), observability (sigma.js graph viz, expanded TUI, /metrics, CLI commands), testing (14 new tests, 40 total), onboarding (demo scripts), and nice-to-haves (multimodal feedback, rate limiting, good-first-issue template).

**Relax / Tension detected**
Highest tension: the full-graph JSON write on every wave cycle (O(n) I/O blocking the wave thread). Secondary: undamped propagation causing activation explosion, no quality gate before model hot-swap, minimal CLI surface vs rich runtime capabilities.

**Break**
Collapsed: full-graph JSON dump pattern, undamped propagation, single-threshold tension detection, unguarded hot-swap, thin CLI, placeholder-only graph viz.

**Evolve**
19 files changed, 1178 insertions: SQLite WAL-mode backend, dirty-node incremental save, configurable pruning policies, schema migration pipeline, wave damping, per-type stability thresholds, 3 new rule types (merge/split/novelty), sigma.js interactive graph visualization, 9-command CLI, quality gate for adapter hot-swap, fine-tune lineage in graph, 40 tests passing.

**Final stable configuration / Answer**
All 7 categories implemented. 40 tests passing. ruff + black clean. Pushed as commit 6529b73.
