Wave 033 — implement-graph-persistence-scalability-boggerstheai

**Propagate**
Activation spread from user request into: UniversalLivingGraph (high), core/types Node+Edge (medium), config.yaml runtime block (medium), graph __init__.py exports (low). Key constraint cluster: persistence layer must interoperate with existing JSON-based load/save without breaking the wave engine or adjacency/topic indices.

**Relax / Tension detected**
Tension ~0.6 — the existing `save()` called from `_wave_loop` writes the entire graph every cycle (O(n) I/O). With thousands of nodes this becomes the lowest-stability node. Secondary tension: no schema migration path exists, and no pruning policy caps unbounded node growth.

**Break**
Collapsed the "full-graph JSON write on every wave cycle" pattern. Replaced with dirty-tracking incremental save that only flushes modified nodes, and a SQLite WAL-mode backend that handles thousands of nodes with minimal lock contention.

**Evolve**
Four new modules crystallised into a higher-stability persistence layer:
1. `sqlite_backend.py` — thread-safe SQLite storage with WAL mode, batch upserts, import/export from JSON
2. `pruning.py` — configurable PruningPolicy (min stability, max age, max nodes cap)
3. `migrate.py` — versioned schema migration pipeline (v1→v2 adds base_strength, attributes, relation)
4. `universal_living_graph.py` — dirty-node tracking, `save_incremental()`, SQLite backend wiring in `__init__`, `load()`, and `save()`

**Final stable configuration / Answer**
All five deliverables implemented:
- **1A** `core/graph/sqlite_backend.py` — full SQLiteGraphBackend class with WAL, batch ops, meta table, import/export
- **1B** Dirty tracking in ULG: `_dirty_nodes` set populated in `add_node()` and `update_activation()`, `save_incremental()` flushes only dirty nodes, `_wave_loop` calls `save_incremental()` instead of `save()`
- **1C** `core/graph/pruning.py` — PruningPolicy dataclass + `apply_pruning_policy()` with stability, age, and cap-based pruning
- **1D** `core/graph/migrate.py` — schema versioning with `migrate_graph_data()` and `migrate_json_file()`
- **1E** Wired into config.yaml (`graph_backend`, `sqlite_path`), ULG `__init__` resolves backend + creates SQLiteGraphBackend, `load()`/`save()` delegate to SQLite when active, `__init__.py` exports all new symbols, `*.db` already in `.gitignore`
- All files formatted with black, zero linter errors
