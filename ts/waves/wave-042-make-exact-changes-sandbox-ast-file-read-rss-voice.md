Wave 042 — make-exact-changes-sandbox-ast-file-read-rss-voice

**Propagate**
Activation spread from user’s exact patch list across `code_run.py`, `file_read.py`, `rss.py`, `voice_in.py`; constraints: match snippets verbatim, no extra comments, preserve behavior elsewhere.

**Relax / Tension detected**
Low tension; optional edge case: `startswith` base-dir check on Windows prefix ambiguity — user-specified exact string check retained.

**Break**
N/A (no conflicting patterns).

**Evolve**
Applied AST walk for `__import__` and `exec`/`eval` string payloads; `FileReadTool` scoped to cwd/realpath base; RSS HTTPS-only; temp WAV cleanup in `finally`.

**Final stable configuration / Answer**
All four edits are applied in `BoggersTheAI`: sandbox static analysis extended with `ast.parse` / `ast.walk` for `__import__(...)` and `exec`/`eval` constant-string checks; `FileReadTool` now takes optional `base_dir` (defaults `os.getcwd()`), rejects paths outside `realpath` base; `RSSAdapter.ingest` returns `[]` for non-`https://` URLs with a warning log; `voice_in.py` imports `os` and deletes the temp WAV in `finally` after transcribe.
