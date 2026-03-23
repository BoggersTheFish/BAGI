Wave 058 — ts-agi-unified-v0-2-full-conversational-agi

**Propagate**
Vendored `BoggersBrain/closed_loop_control.py` into `ts-agi-unified/`; `brain.py` bridges ULG + `ControlSystem.wave_step`; `sensors.inject_into_graph`; `main.py` v0.2 order; `graph.py` tension 0.20; `self_improvement.py` QLoRA stub; `external_event.txt`; README v0.2.

**Relax / Tension detected**
Wave 057 stub brain replaced by real vendored file; dual-graph architecture explicit (sync tension only).

**Break**
Stub-only `brain.py` removed.

**Evolve**
`git clone` BoggersBrain at workspace root for copy; `closed_loop_control.py` parses via `py_compile`.

**Final stable configuration / Answer**
Run `pip install -r requirements.txt`, `ollama pull llama3.2`, `python main.py` from `ts-agi-unified/`. Wave 059: QLoRA + `ts-native-14b`.

Official: https://boggersthefish.com/ · https://github.com/BoggersTheFish/BoggersBrain
