Wave 040 — replace-examples-readme-comprehensive-guide

**Propagate**
User requested replacing `BoggersTheAI/examples/README.md` with a full guide: prerequisites, per-example documentation, tips, and connection to `BoggersRuntime`/CLI. Activation spread to example scripts, `QueryResponse`, wave/OS loop code paths, and `config.yaml` for factual alignment.

**Relax / Tension detected**
`graph_evolution_demo.py` calls `core.wave.run_wave()` (propagate → relax with contradiction handling → break → evolve), not the full `UniversalLivingGraph` background loop that logs prune/emergence. Tension: user bullet list vs. demo scope. Resolved by describing what the script actually runs and pointing to `BoggersRuntime`/autonomous demo for prune/emergence in the living graph.

**Break**
Omitting the assumption that the evolution demo alone exercises `graph.prune()` and `spawn_emergence()` as in background waves.

**Evolve**
README documents `run_wave()` as the focused TS-OS stepper in that file, relates concepts to the full pipeline, and keeps quickstart accurate (prints answer/hypotheses; documents full `QueryResponse` fields).

**Final stable configuration / Answer**
Wrote `BoggersTheAI/examples/README.md` with title, prerequisites (Python 3.10+, editable install, Ollama), detailed sections for each example and notebook, tips (Ollama, `inference.ollama.enabled`, `wave.interval_seconds`, CLI `graph stats`, traces), and a closing note that examples use the same runtime as the CLI. Updated `ts/CURRENT-WAVE.txt` to `041`.
