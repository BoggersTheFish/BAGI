Wave 055 — ollama-port-11434-already-in-use

**Propagate**
User hit `bind: Only one usage of each socket address` on 127.0.0.1:11434 — Ollama already listening (typical on Windows).

**Relax / Tension detected**
Tension: assumed need to run `ollama serve` manually vs tray/service already bound.

**Break**
N/A.

**Evolve**
Stable config: use existing server; optional restart via Task Manager or `Get-NetTCPConnection`/taskkill.

**Final stable configuration / Answer**
Port 11434 in use = **Ollama is already running** (often auto-starts with Windows). You usually **do not** need `ollama serve`. Run `ollama list` or open the Ollama app; use BoggersTheAI against `http://localhost:11434`. To free the port: quit Ollama from system tray or end `ollama.exe` / restart the Ollama service.

Official: https://ollama.com/
