Wave 021 — track-e-step-3-auto-scheduling-validation-safety

**Propagate**
Activated nodes: auto-scheduling in runtime OS loop, trace-threshold trigger policy, validation gate, rollback safety path, and persistent self-improvement state.

**Relax / Tension detected**
Main tension was balancing autonomous fine-tune behavior with safety defaults. Resolved by enforcing `safety_dry_run`, explicit condition checks, and non-destructive rollback.

**Break** (if applicable)
Collapsed unconditional hotswap pattern by introducing validation-based swap gating (`new val_loss < best_val_loss`) and backup restore behavior.

**Evolve**
System now tracks `last_fine_tune_time`, `last_tuned_trace_count`, `best_val_loss`, supports nightly/threshold auto-triggering, and exposes manual `trigger_self_improvement()`.

**Final stable configuration / Answer**
Track E Step 3 is implemented:
- Runtime includes auto-scheduling checks (`_auto_fine_tune_check`) with nightly and new-trace threshold conditions.
- `fine_tune_and_hotswap()` now validates against prior best val loss and only swaps on improvement.
- Adapter rollback safety added via backup copy and `LocalLLM.load_previous_adapter()`.
- Fine-tuner returns `val_loss` and supports validation/safety flags.
- Config now includes `auto_schedule`, `min_new_traces`, `validation_enabled`, `max_memory_gb`, and `safety_dry_run`.
