Wave 023 — create-two-foundation-modules-boggers-ai

**Propagate**
Activation spread from config.yaml (108 lines, 11 top-level sections) → RuntimeConfig dataclass (slots=True) → core/__init__.py (existing exports) → pyproject.toml (dependencies). Key constraint: slots=True on RuntimeConfig blocks arbitrary setattr for new fields, so config_loader must return raw yaml dict rather than forcibly attach extra attrs.

**Relax / Tension detected**
Tension ~0.3 — moderate. The slots=True constraint on RuntimeConfig means apply_yaml_to_config can only set fields that already exist on the dataclass. Lowest-stability node: the original plan to object.__setattr__ modules/adapters/tools/multimodal onto a slotted class. That would fail at runtime.

**Break**
Collapsed the "force extra attrs onto slots dataclass" pattern. Replaced with clean separation: apply_yaml_to_config only touches existing dataclass fields; load_and_apply returns the full yaml dict so runtime can hold it as self.raw_config for querying modules/adapters/tools/multimodal sections directly.

**Evolve**
Four-file stable configuration:
1. `core/config_loader.py` — load_yaml with lazy PyYAML import, _deep_merge, apply only to known fields, return raw dict
2. `core/logger.py` — structured logging under "boggers" namespace, auto-initialised on import
3. `core/__init__.py` — re-exports all new names in sorted __all__
4. `pyproject.toml` — pyyaml added to dependencies list

**Final stable configuration / Answer**
All four tasks completed:

- **core/config_loader.py** created with `find_config`, `load_yaml`, `_deep_merge`, `apply_yaml_to_config`, and `load_and_apply`. Handles slots-safe field setting and returns raw yaml for runtime to store separately.
- **core/logger.py** created with `get_logger` and `setup_logging`, auto-initialising on import.
- **core/__init__.py** updated with imports and __all__ entries for `load_yaml`, `apply_yaml_to_config`, `load_and_apply`, `find_config`, `get_logger`, `setup_logging`.
- **pyproject.toml** updated — `pyyaml` added to `dependencies`.
