Wave 025 — implement-improvements-localllm-finetuner-entities

**Propagate**
Activation spread across four source files: local_llm.py, fine_tuner.py, consolidation.py, insight.py. Key active nodes: logging infrastructure, LoRA config surface, exception handling patterns, health-check interface, consolidation metrics. Cross-file constraint: all changes must preserve existing behaviour while adding observability and configurability.

**Relax / Tension detected**
Tension ~0.4 in fine_tuner.py — six new config fields needed wiring through dataclass, fine_tune(), and _resolve_config() simultaneously. Lowest-stability node: hardcoded LoRA hyperparameters (r=16, target_modules list literal, batch_size=2, gradient_accumulation_steps=4) — brittle to any model/hardware change.

**Break**
Collapsed hardcoded LoRA values in fine_tune() → replaced with self.config.* references. Collapsed bare `except Exception: pass` pattern in local_llm.py (two sites) and consolidation.py (two sites) → replaced with named captures + logger calls.

**Evolve**
Higher-stability configuration emerged:
- local_llm.py: logger("boggers.llm"), configurable max_seq_length in load_adapter, health_check() method
- fine_tuner.py: logger("boggers.finetune"), 6 new FineTuningConfig fields (lora_r, lora_alpha, lora_dropout, target_modules, batch_size, gradient_accumulation_steps), GPU memory pre-check, structured training log
- consolidation.py: logger("boggers.consolidation"), debug-logged exception handlers, candidates_count metric
- insight.py: logger("boggers.insight")

**Final stable configuration / Answer**
All 9 improvements (5.1–5.3, 6.1–6.3, 8.1–8.3 + insight logging) implemented across 4 files:

**local_llm.py (5.1–5.3):**
- 5.1: Added `logging` import + `logger = logging.getLogger("boggers.llm")`. Replaced bare `except Exception:` in `load_adapter` and `_run_generation` with named `exc` + `logger.warning(...)`.
- 5.2: `load_adapter` now accepts `max_seq_length: int = 2048`; passed through to `FastLanguageModel.from_pretrained`.
- 5.3: New `health_check() -> dict` method returns model status, adapter state, and generation capability.

**fine_tuner.py (6.1–6.3):**
- 6.1: `FineTuningConfig` gains `lora_r`, `lora_alpha`, `lora_dropout`, `target_modules`, `batch_size`, `gradient_accumulation_steps`. All wired into `fine_tune()` and `_resolve_config()`.
- 6.2: `logger.info(...)` after `trainer.train()` logs epochs, loss, duration, adapter path.
- 6.3: GPU memory check before training warns if VRAM < 50% of `max_memory_gb`.

**consolidation.py (8.1–8.3):**
- 8.1: Already had configurable `similarity_threshold` — verified, no change needed.
- 8.2: Replaced `except AttributeError: pass` → `except (AttributeError, KeyError) as exc: logger.debug(...)`. Replaced `except KeyError: pass` → `except KeyError as exc: logger.debug(...)`.
- 8.3: Added `candidates_count` field to `ConsolidationResult`, populated in `consolidate()`.

**insight.py:**
- Added `logging` import + `logger = logging.getLogger("boggers.insight")`. No print statements existed to replace.
