Wave 051 — continue-wave-050-close-loop

**Propagate**
Activation: Wave 050 scope (Grok bundle, CPU stats, folded-wave Cytoscape, config clarity); nodes: `meta_critique.py`, `fine_tuner.py`, `universal_living_graph.py`, `dashboard/app.py`, `mind/tui.py`, `config.yaml`, `config_schema.py`, tests.

**Relax / Tension detected**
Prior tension: dashboard/TUI lacked CPU + folded-wave surfacing; graph API had no folded list; ruff E501 on long lines. Estimated tension → low after merge.

**Break**
N/A — no contradictory pattern; extended existing metrics/graph paths.

**Evolve**
- `folded_wave_nodes()` on `UniversalLivingGraph`; `/metrics` exposes `cpu_distillora`, `folded_wave_nodes`, `folded_wave_count`; Cytoscape style `folded_wave=1` (purple).
- `cpu_distillora_stats.json` includes `sample_run` block; TUI shows CPU row + folded count.
- Config comments for meta_critique + `fold_waves_jsonl_on_startup`; schema comment for finetune tracks.
- Tests: dashboard mocks, `test_folded_wave_nodes_api`, NEXT_GROK_PROMPT asserts full bundle (`git add`).
- Ruff clean; pytest green (Windows logging teardown noise only).

**Final stable configuration / Answer**
Wave 050 implementation complete locally: commit pushed as `Wave 050 — grok-ts-agent-live-github-ts-eval-real-sync | closed auto-paste loop + CPU dashboard viz + live wave nodes | stability +0.12`. Remote: `BoggersTheFish/BoggersTheAI` main. Next: Grok runs Wave 051 eval; optional fix logging stream on Windows teardown.
