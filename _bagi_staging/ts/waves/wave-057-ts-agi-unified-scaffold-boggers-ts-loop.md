Wave 057 — ts-agi-unified-scaffold-boggers-ts-loop

**Propagate**
User spec for `ts-agi-unified` one-folder AGI; activation: scaffold under `BoggersTheWorkspace/ts-agi-unified` with runnable `main.py`, fixed requirements (no pip sqlite3), stub brain, graph+sensors, .env.example, README.

**Relax / Tension detected**
Spec had broken imports (`Node` in main), `numpy` missing in sensors, `sqlite3` in requirements, hardcoded `ts-native-14b` without training. Resolved in scaffold.

**Break**
Full BoggersBrain 16-D port deferred — `ControlSystem` stub until repo graft.

**Evolve**
Minimal loop: wave → brain.step → ollama.chat(llama3.2 default); protected `user`/`self` from prune.

**Final stable configuration / Answer**
Folder created; run `pip install -r requirements.txt`, `ollama pull llama3.2`, `python main.py` from `ts-agi-unified/`.

Official: https://boggersthefish.com/ · https://github.com/BoggersTheFish/BoggersTheAI
