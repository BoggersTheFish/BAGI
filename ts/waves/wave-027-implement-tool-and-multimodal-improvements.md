Wave 027 — implement-tool-and-multimodal-improvements

**Propagate**
Activation spread from config.yaml (code_run_timeout_seconds) → ToolExecutor → CodeRunTool; from FileReadTool → path validation; from SearchTool → base_url; from executor/router → logging; from multimodal adapters → real backend dispatch (faster-whisper, piper, blip2); from whisper.py/clip_embed.py → thin wrapper pattern.

**Relax / Tension detected**
Tension ~0.6: ToolExecutor had no timeout passthrough (violated config contract). FileReadTool had no extension guard (security gap). SearchTool had hardcoded URL (inflexible). Executor/router had zero observability (debugging blind spot). Multimodal adapters were pure placeholders (no real backend attempt). voice_out.py config field was `voice` not `model` (schema drift with request). ImageInConfig had `include_embedding_hint` not `model_name` (schema update needed).

**Break**
Collapsed: placeholder-only multimodal implementations, missing timeout wiring, hardcoded search URL, zero logging in tool pipeline, missing path traversal guard.

**Evolve**
New stable structure across 10 files:
- executor.py: dataclass gains `timeout_seconds` field, `with_defaults(timeout_seconds=5)` passes it to CodeRunTool, execute() logs entry/exit
- code_run.py: already had timeout_seconds — no change needed
- file_read.py: os.path.realpath + ALLOWED_EXTENSIONS guard before any read
- search.py: `__init__(base_url=...)` replaces hardcoded URL
- router.py: logger on every routing decision branch
- voice_in.py: tries faster-whisper → falls back to placeholder
- voice_out.py: tries piper subprocess → falls back to text bytes
- image_in.py: tries BLIP2 via transformers → falls back to placeholder
- whisper.py: thin wrapper pinning backend="faster-whisper"
- clip_embed.py: thin wrapper pinning backend="clip"

**Final stable configuration / Answer**
All 8 improvements (10.1–10.4, 11.1–11.4) implemented:

**10.1** — `ToolExecutor` now accepts `timeout_seconds` in both `__init__` (dataclass field) and `with_defaults()`, forwarding it to `CodeRunTool(timeout_seconds=...)`.

**10.2** — `FileReadTool.execute()` resolves paths via `os.path.realpath()` and rejects extensions outside `ALLOWED_EXTENSIONS` (.txt, .md, .py, .json, .yaml, .yml, .csv, .log).

**10.3** — `SearchTool.__init__` accepts `base_url` (default: HN Algolia). The execute method uses `self.base_url` instead of the hardcoded string.

**10.4** — `boggers.tools` logger in executor.py logs tool name + args on entry and result char-count on exit. `boggers.tools.router` logger in router.py logs every routing decision with the matched tool and key args.

**11.1** — `VoiceInAdapter` attempts `faster-whisper` transcription (lazy-loaded model, temp WAV file), falls back to the placeholder on ImportError or any exception.

**11.2** — `VoiceOutAdapter` attempts Piper TTS via subprocess, falls back to UTF-8 text bytes.

**11.3** — `ImageInAdapter` attempts BLIP2 captioning via transformers + PIL (lazy-loaded), falls back to placeholder string.

**11.4** — Backend dispatch is driven by `self.config.backend` in each adapter. `WhisperAdapter` and `ClipCaptionAdapter` are thin wrappers that force-set the backend field before calling `super().__init__`.
