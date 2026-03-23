Wave 051 — runtime-py-four-fixes-llm-lock-try-except

**Propagate**
Activation spread from `runtime.py` edits: threading lock for LLM coordination, resilient transcribe/caption/backup paths, quality gate reusing `self.local_llm` under `_llm_lock`.

**Relax / Tension detected**
Constraint: implement four user-specified patches exactly; `adapter_path` in `_run_quality_gate` is now unused by body (caller contract preserved). Tension low.

**Break** (if applicable)
N/A — pattern replaced: separate `LocalLLM` for quality gate removed in favor of shared instance + lock.

**Evolve**
`BoggersRuntime` now has `_llm_lock`, try/except on voice and image I/O, guarded backup `copytree`, and `_run_quality_gate` short-circuits when no LLM or runs `summarize_and_hypothesize` under the lock.

**Final stable configuration / Answer**
All four changes are applied in `BoggersTheAI/interface/runtime.py`: (1) `self._llm_lock = threading.Lock()` after `_last_conversation_node_id` and before `ModeManager`; (2) `ask_audio` / `ask_image` wrap `transcribe` / `caption` in try/except with the specified fallbacks and log warnings; (3) `shutil.copytree` in `fine_tune_and_hotswap` is in try/except, sets `backup_path = None` on failure; (4) `_run_quality_gate` returns `{"passed": True, "reason": "no_llm_to_test"}` when `self.local_llm is None`, otherwise calls `self.local_llm.summarize_and_hypothesize(...)` inside `with self._llm_lock`. `ts/CURRENT-WAVE.txt` incremented to 052.
