Wave 038 — explore-project-improvements-optimisations-growth

**Propagate**
Full codebase scan: 4 parallel agents covered core/graph, runtime/interface, adapters/tools/tests, and architecture/growth. Every .py file analyzed.

**Relax / Tension detected**
Tension: high across unused infrastructure (EventBus, PluginRegistry, HealthChecker, MetricsCollector all exported but never wired), thread safety gaps (api singleton, hypothesis queue, LLM access), O(n²) loops in contradiction/embeddings, god-object BoggersRuntime, missing test coverage across adapters/tools/multimodal/dashboard.

**Break**
Collapsed naive "everything is fine" configuration into 150+ specific improvement items with severity and fix suggestions.

**Evolve**
Comprehensive audit organized into: Bugs, Performance, Security, Architecture, Dead Code, Tests, Observability, Scalability, Growth Features.

**Final stable configuration / Answer**
See below for the full categorized list.
