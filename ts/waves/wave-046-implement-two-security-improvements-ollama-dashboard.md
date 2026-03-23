Wave 046 — implement-two-security-improvements-ollama-dashboard

**Propagate**
Activation spread from LocalLLM Ollama client config, dashboard bind/auth, and YAML inference.ollama; runtime wiring connects config to LocalLLM constructors.

**Relax / Tension detected**
Constraint: config key inference.ollama.base_url must reach LocalLLM; two LocalLLM construction sites in runtime. Low tension after wiring both paths.

**Break** (if applicable)
Hardcoded localhost Ollama and 0.0.0.0 dashboard default collapsed in favor of explicit configurable URL and loopback default.

**Evolve**
ollama.Client(host=...) on LocalLLM; base_url in config.yaml; runtime passes base_url; dashboard defaults to 127.0.0.1 with token warning and production comment for 0.0.0.0 behind reverse proxy.

**Final stable configuration / Answer**
Implemented: (1) `LocalLLM` takes `base_url` (default `http://localhost:11434`), stores `self._client = ollama.Client(host=self._base_url)`, uses `self._client.chat` and `self._client.embeddings`; `config.yaml` has `inference.ollama.base_url`; `interface/runtime.py` passes it from `ollama_cfg` in both LocalLLM instantiations. (2) Dashboard `main()` default host `127.0.0.1`, logs warning if `BOGGERS_DASHBOARD_TOKEN` unset, comment on using `0.0.0.0` behind reverse proxy in production.
