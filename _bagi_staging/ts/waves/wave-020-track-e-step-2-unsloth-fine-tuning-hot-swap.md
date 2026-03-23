Wave 020 — track-e-step-2-unsloth-fine-tuning-hot-swap

**Propagate**
Activated nodes: Track E Step 2 scope, `core/fine_tuner.py`, runtime hotswap wiring, local adapter-aware inference, dependency/config alignment.

**Relax / Tension detected**
Constraint checks passed for scope isolation (only fine-tuning and hotswap touched). Residual tension: local environment may not have `unsloth` installed, so runtime path must fail safely.

**Break** (if applicable)
Collapsed assumption that training dependencies are always present by introducing guarded imports and structured failure stats instead of hard crashes.

**Evolve**
Introduced `UnslothFineTuner` with QLoRA-ready training path, runtime `fine_tune_and_hotswap()`, adapter-aware `LocalLLM`, and config/dependency surface for automatic model improvement.

**Final stable configuration / Answer**
Track E Step 2 is implemented in `BoggersTheAI` with a complete Unsloth fine-tuning pipeline and runtime hot-swap hooks:
- New `core/fine_tuner.py` trains on `dataset/train.jsonl` and writes adapters to `models/fine_tuned_adapter`.
- `BoggersRuntime` now owns `self.fine_tuner` and exposes `fine_tune_and_hotswap()`.
- `LocalLLM` accepts `adapter_path`, attempts Unsloth/PEFT adapter loading, and falls back to Ollama.
- `config.yaml`, `pyproject.toml`, and `.gitignore` are updated for fine-tuning settings and artifacts.
