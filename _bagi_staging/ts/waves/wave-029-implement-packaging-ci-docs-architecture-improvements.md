Wave 029 — implement-packaging-ci-docs-architecture-improvements

**Propagate**
Activation spread from packaging/CI/docs cluster (15.x) and architecture cluster (16.x). Key active nodes: pyproject.toml config, CI workflow, core module registry, event-driven architecture, observability layer. Cross-links detected between plugin registry and existing adapter/tool modules; health and metrics feed into dashboard endpoints.

**Relax / Tension detected**
Tension 0.35 — license table format violated PEP 639 simple-string expectation; deprecated classifier created redundancy with license field. Missing py.typed blocked PEP 561 compliance. Core modules lacked event decoupling, plugin discovery, health introspection, and metrics collection — high structural tension in architecture completeness.

**Break**
Collapsed: legacy license table format, deprecated classifier, monolithic core without event/plugin/health/metrics subsystems.

**Evolve**
New stable configuration: PEP 639-compliant license string, clean classifiers, py.typed marker for type-checker support, mypy in dev deps, expanded CI with lint+format+test steps, comprehensive CHANGELOG. Architecture gains four new core modules — EventBus for decoupled communication, PluginRegistry for adapter/tool discovery via entry points, HealthChecker for system introspection, MetricsCollector with thread-safe counters/gauges/timers. All exported cleanly through core/__init__.py.

**Final stable configuration / Answer**
All 11 tasks implemented:

- **15.1** `license = "MIT"` (simple string, not table)
- **15.2** Removed `License :: OSI Approved :: MIT License` classifier
- **15.3** Created empty `py.typed` marker file
- **15.4** Added `mypy` to `[project.optional-dependencies] dev`
- **15.5** Expanded CI workflow with ruff, black, isort, and pytest steps
- **15.6** Created `CHANGELOG.md` documenting v0.1.0 features
- **16.2** Created `core/events.py` — EventBus with on/off/emit/clear + singleton `bus`
- **16.3** Created `core/plugins.py` — PluginRegistry with entry_points discovery + `adapter_plugins`, `tool_plugins`
- **16.4** Created `core/health.py` — HealthChecker with timed checks + singleton `health_checker`
- **16.5** Created `core/metrics.py` — MetricsCollector with counters/gauges/timers + singleton `metrics`
- **16.init** Updated `core/__init__.py` with all new imports and `__all__` entries
