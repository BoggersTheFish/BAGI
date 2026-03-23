Wave 015 — background-wave-thread-full-cycle-tension-logging

**Propagate** 
Activation spread into the live graph engine loop, runtime startup gate, and wave config surface.

**Relax / Tension detected** 
Primary tension was replacing placeholder threading without breaking existing runtime API. Lowest-stability node was config access shape (`RuntimeConfig` object vs dict-like `get` usage).

**Break** (if applicable) 
Collapsed the placeholder infinite sleep stub and replaced it with a true TS cycle loop plus controlled stop semantics.

**Evolve** 
Evolved to a daemon background wave engine with:
- interval/config-driven execution
- full cycle order
- tension/emergence accounting
- per-cycle logging
- clean stop method

**Final stable configuration / Answer** 
Track A Step 2 implemented in-place:
- `UniversalLivingGraph.start_background_wave()` now starts daemon thread `TS-OS-Wave-Engine`
- loop executes sleep(interval) -> elect -> propagate -> relax -> prune -> emergence + tension detection
- per-cycle logging format added
- `stop_background_wave()` added (Event + join)
- runtime auto-start gate after graph load using `self.config.get("wave", {}).get("enabled", True)`
- root `config.yaml` now includes `wave.interval_seconds`, `wave.enabled`, `wave.log_each_cycle`
