Wave 056 — ollama-list-empty-pull-model

**Propagate**
`ollama list` empty → no models pulled; Boggers default `config.yaml` uses `llama3.2`.

**Relax / Tension detected**
Server runs but no weights locally — pull required.

**Break**
N/A.

**Evolve**
Stable: `ollama pull llama3.2` (or match config).

**Final stable configuration / Answer**
Empty list is normal until you download a model. Run `ollama pull llama3.2` (or the model name in `config.yaml` under `inference.ollama.model`).

Official: https://ollama.com/ · https://boggersthefish.com/
