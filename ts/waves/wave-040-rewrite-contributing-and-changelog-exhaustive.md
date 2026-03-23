Wave 040 — rewrite-contributing-and-changelog-exhaustive

**Propagate** 
Activation spread from: CONTRIBUTING.md (existing structure), CHANGELOG.md (existing entries v0.1–v0.3), pyproject.toml (dependency groups, tool config), .github/workflows/test.yml (CI matrix), ARCHITECTURE.md (directory layout, thread model, persistence), all 106 Python source files (directory structure verification), core/protocols.py, core/config_resolver.py, core/config_schema.py (Phase 1-6 additions).

**Relax / Tension detected** 
Tension 0.7 — existing CONTRIBUTING.md was sparse (93 lines, missing adapter/tool/health/metric/event/temperament how-tos, no CI detail, no security table, no config philosophy). CHANGELOG.md was missing the entire v0.4.0 entry covering 6 phases of hardening work. Both files under-represented the project's current state.

**Break** 
Collapsed the shallow CONTRIBUTING.md template — it lacked how-to guides for extending every subsystem and had no security guidelines or configuration philosophy sections. The CHANGELOG gap (no v0.4.0) misrepresented project maturity.

**Evolve** 
CONTRIBUTING.md rebuilt as a 300+ line comprehensive guide with: full TOC, all optional dependency groups, exact directory tree with per-file descriptions, quality check table, CI pipeline step-by-step, code style principles, 6 detailed how-to guides (adapter, tool, health check, metric, event, temperament), PR guidelines, commit style, config philosophy, security table, and issue reporting. CHANGELOG.md gained a thorough v0.4.0 entry with Added (16 items), Changed (9 items), Fixed (8 items), and Security (7 items) sections — all prior entries preserved.

**Final stable configuration / Answer** 
Both files have been completely rewritten:
- CONTRIBUTING.md: exhaustive contributor guide covering every aspect of the project from setup through extending each subsystem, with code style, security, config philosophy, and PR guidelines.
- CHANGELOG.md: new v0.4.0 entry documenting all Phase 1-6 improvements (protocols, config validation, performance, thread safety, security hardening, CI, tests) with all existing v0.1.0–v0.3.0 entries preserved.
