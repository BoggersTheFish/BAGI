Wave 040 — fix-ci-ruff-e501-errors

**Propagate**
Activation from CI failure screenshot → 27 E501 (line too long > 88) ruff errors across 10 files: core/contradiction.py, core/graph/universal_living_graph.py, core/local_llm.py, core/query_processor.py, core/temperament.py, dashboard/app.py, examples/graph_evolution_demo.py, interface/chat.py, interface/runtime.py, mind/tui.py.

**Relax / Tension detected**
Tension: 0.90 — CI pipeline failing on Python 3.12 quality job. All other jobs (3.10, 3.11) also fail on ruff step. Lowest-stability nodes: long f-strings, logger format strings, embedded HTML/CSS/JS in dashboard, temperament description strings.

**Break**
Collapsed all 27 overlong lines by splitting f-strings into multi-line implicit concatenation, extracting intermediate variables, breaking HTML/CSS/JS in embedded strings, and shortening description texts.

**Evolve**
3 parallel agents fixed all 10 files. Black auto-formatted one remaining file. Final verification: ruff (all checks passed), black (106 files unchanged), pytest (147 passed in 9.5s).

**Final stable configuration / Answer**
All 27 E501 errors resolved. Committed and pushed to GitHub (6bd62e8..7b625bb main -> main). CI should now pass on all Python versions.
