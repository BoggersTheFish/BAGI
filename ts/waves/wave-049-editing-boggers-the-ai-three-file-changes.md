Wave 049 — editing-boggers-the-ai-three-file-changes

**Propagate** 
Activation spread through `universal_living_graph` wave loop, `chat` CLI, and `dashboard` metrics endpoint; EventBus, health checks, and MetricsCollector nodes engaged.

**Relax / Tension detected** 
Constraints satisfied: `bus.emit` signature matches `events.py`; `run_health_checks` exists on runtime; `metrics.snapshot()` present. Low tension.

**Break** (if applicable) 
N/A — no weak pattern collapsed.

**Evolve** 
Integrated `wave_cycle` emissions after each background wave cycle, CLI `health` command with help line, and `/metrics` response extended with `system` snapshot from `metrics_collector`.

**Final stable configuration / Answer** 
Implemented all three requested edits in `BoggersTheAI`:

1. **`core/graph/universal_living_graph.py`** — Added `from ..events import bus` and, after the per-cycle logging block and before the `auto_save` block, `bus.emit("wave_cycle", cycle=..., tension=..., nodes=..., pruned=..., emergent=...)`.

2. **`interface/chat.py`** — Added `health` / `/health` command (calls `rt.run_health_checks()`, prints overall and per-check lines) and help line for health before history.

3. **`dashboard/app.py`** — Imported `metrics as metrics_collector` from `BoggersTheAI.core.metrics`; `/metrics` uses `graph_metrics` for graph data and adds `"system": metrics_collector.snapshot()` to the JSON response.

Imports verified with `python -c` from the package directory.
