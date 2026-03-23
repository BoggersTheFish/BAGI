Wave 010 — complete-main-boggerstheai-plan-integration

**Propagate** 
Activation spread from unresolved plan nodes (`core/router.py`, root config, inference throttle/router, interface layer) into integration components and runtime wiring.

**Relax / Tension detected** 
Remaining tension was architectural glue rather than feature modules. Lowest-stability nodes were orchestration boundaries between query flow, adapters, and autonomous cycles.

**Break** (if applicable) 
Collapsed placeholder-only orchestration by implementing concrete runtime/router layers and module wiring from interface to core to entities/adapters/tools/multimodal.

**Evolve** 
Evolved to an end-to-end modular system with:
- orchestrator router
- inference throttle+fallback router
- runtime composition root
- API/chat interface entry points
- root deployment/config controls

**Final stable configuration / Answer** 
Completed remaining main-plan integration work in `BoggersTheAI`:
- Implemented `core/router.py`:
  - `QueryRouter` for USER-mode processing, autonomous cycles, multimodal entry points
  - `RegistryIngestAdapter` bridge for adapter registry fan-out
  - `RouterConfig`
- Added inference routing/throttling:
  - `entities/inference_router.py` with `InferenceRouter` and `ThrottlePolicy`
- Added interface composition and entry points:
  - `interface/runtime.py` (`BoggersRuntime`) wiring graph/core/entities/adapters/tools/multimodal
  - `interface/api.py` request handler
  - `interface/chat.py` minimal interactive CLI loop
  - updated `interface/__init__.py` exports
- Filled root `config.yaml` with module toggles, inference throttle settings, runtime options, deployment tiers.
- Updated package exports:
  - `core/__init__.py`
  - `entities/__init__.py`
  - root `__init__.py`

Validation:
- `python -m compileall BoggersTheAI` passed after all changes.
- No linter errors in changed files.
