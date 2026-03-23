# ts-agi-unified **v0.2** — full conversational loop

Single folder, **`python main.py`**:  

1. **`UniversalLivingGraph`** (`graph.py`) — propagate / relax / tension / break-evolve + `persistence/wave_history.jsonl`.  
2. **Vendored BoggersBrain** — `closed_loop_control.py` copied verbatim from [BoggersBrain](https://github.com/BoggersTheFish/BoggersBrain) (`closed_loop_control.py` on `main`). Own 4-node internal graph (16-D), **not** merged into `UniversalLivingGraph`.  
3. **`brain.py`** — injects user text into `external_event.txt` (scalar) so Phase-5 `read_external_event_vec` blends it; calls `ControlSystem.wave_step()`; syncs a **blended** tension back onto the ULG.  
4. **Ollama** — after graph + brain steps, synthesis with `OLLAMA_MODEL` (default `llama3.2`).

## Quick start (Windows)

```powershell
cd ts-agi-unified
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
copy .env.example .env
ollama pull llama3.2
python main.py
```

Optional: set `BRAIN_EMBODIMENT=y`, `BRAIN_VISION_SYMBOLS=y`, `BRAIN_SELF_FEATURE=y`, `BRAIN_CHECKPOINT=1` (see BoggersBrain env flags in `closed_loop_control.py`).

## Layout

| File | Role |
|------|------|
| `closed_loop_control.py` | **Vendored** BoggersBrain closed loop (ControlSystem + wave_step + …) |
| `brain.py` | Bridge: `TsAgiBrain` + `create_control_system()` |
| `graph.py` | Conversational `UniversalLivingGraph` |
| `sensors.py` | `UserInputSensor` + `inject_into_graph` |
| `main.py` | CLI loop |
| `self_improvement.py` | QLoRA stub (Wave 059 — point at BoggersTheAI) |
| `control_value.txt`, `control_target.txt`, `external_event.txt` | Read/written by `closed_loop_control` (paths relative to that file) |

## What’s real vs next wave

| Piece | Status |
|-------|--------|
| BoggersBrain loop | **Full file** `closed_loop_control.py` |
| ULG + BoggersBrain merge | **Dual graphs** — tension **synced** only (no shared node store) |
| QLoRA `ts-native-14b` | **Wave 059** — `self_improvement.py` + BoggersTheAI |

## Official TS links

- https://boggersthefish.com/
- https://github.com/BoggersTheFish/BoggersTheAI
- https://github.com/BoggersTheFish/BoggersBrain
- https://github.com/BoggersTheFish/GOAT-TS
- https://github.com/BoggersTheFish/TS-Core

## requirements.txt

- Do **not** `pip install sqlite3` — stdlib.
- `torch` / `unsloth` commented until you run QLoRA training.
