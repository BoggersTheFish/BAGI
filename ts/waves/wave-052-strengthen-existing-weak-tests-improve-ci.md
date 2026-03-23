Wave 052 — strengthen-existing-weak-tests-improve-ci

**Propagate**
Activation spread across test_consolidation, test_events_metrics, test_wave_detailed, and CI workflow; ConsolidationEngine Jaccard/merge rules and relax() overflow behavior pinned as constraints.

**Relax / Tension detected**
Prior tests admitted vacuous truth (hasattr, no post-error bus check, len >= 0); CI masked mypy and used low coverage floor.

**Break**
Weak assertions and non-blocking typecheck removed in favor of observable outcomes.

**Evolve**
Graph-based merge/collapse checks, bus recovery after handler failure, real relax overflow assertions, stricter CI with pip cache and cov 60.

**Final stable configuration / Answer**
Implemented: (1) Three-topic consolidation test with merged_count >= 1 and any node collapsed; (2) Event bus registers a follow-up handler after error and verifies emit; (3) relax test asserts tensions or capped activation after overflow; (4) workflow adds actions/cache after checkout, cov-fail-under 60, blocking mypy.
