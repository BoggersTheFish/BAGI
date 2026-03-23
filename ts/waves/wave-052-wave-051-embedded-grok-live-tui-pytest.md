Wave 052 — wave-051-embedded-grok-live-tui-pytest

**Propagate**
Wave 051 scope: `embedded_full_cursor_prompt` on every `waves.jsonl` row, live TUI (8 Hz + folded in events), Cytoscape `/graph` polling, pytest stderr consolidation skip, `config.yaml` clarity, runtime shutdown guards.

**Relax / Tension detected**
Micro-tensions: Grok block not embedded per JSONL line; TUI/dashboard not live enough; Windows pytest logging spam. Addressed.

**Break**
N/A.

**Evolve**
- `meta_critique`: each non-suppressed log line includes full paste bundle; `_emit_next_grok_prompt` reuses precomputed bundle.
- `tui`: 8 FPS, 250 ms tick, recent events show `folded=N`.
- `dashboard` `/graph/viz`: `setInterval` refresh, stable edge ids, live node/edge counts in header.
- `tests/conftest`: `BOGGERS_SKIP_SHUTDOWN_CONSOLIDATION` at import; `runtime.shutdown` respects env + `sys.is_finalizing()`.
- Tests assert embedded prompt + graph viz polling.

**Final stable configuration / Answer**
Wave 051 ready to push: pytest + ruff clean; commit `Wave 051 — grok-ts-agent-live-github-ts-eval-recheck | embedded auto-paste block + live TUI refresh + pytest fix | stability +0.11`.

Official: https://boggersthefish.com/ · https://github.com/BoggersTheFish/BoggersTheAI · https://github.com/BoggersTheFish/GOAT-TS · https://github.com/BoggersTheFish/TS-Core · https://github.com/BoggersTheFish/BoggersTheMind · https://github.com/BoggersTheFish
