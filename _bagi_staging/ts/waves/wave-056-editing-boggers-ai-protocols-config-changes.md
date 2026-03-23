Wave 056 — editing-boggers-ai-protocols-config-changes

**Propagate**
Activation spread through BoggersTheAI/core: new protocols module, config resolver/schema, router and multimodal re-exports, config_loader validation, and core package exports.

**Relax / Tension detected**
Constraint: multimodal/base relative import to ..core requires importing as package `BoggersTheAI` from workspace root (not bare `core` from inside BoggersTheAI folder). No unresolved conflict for duplicate GraphProtocol: core/__init__ now exports GraphProtocol from protocols; query_processor retains its local protocol for typing.

**Break** (if applicable)
N/A

**Evolve**
Single source for voice/image/graph protocols in core/protocols.py; backward compat via multimodal.base re-export; config validated on load when YAML is non-empty.

**Final stable configuration / Answer**
Implemented all requested edits:

1. Added `core/protocols.py` with `VoiceInProtocol`, `VoiceOutProtocol`, `ImageInProtocol`, and `GraphProtocol`.
2. `core/router.py` now imports `ImageInProtocol`, `VoiceInProtocol` from `.protocols`.
3. Replaced `multimodal/base.py` with re-exports from `..core.protocols` and `__all__`.
4. Added `core/config_resolver.py` (`resolve_nested`) and `core/config_schema.py` (`validate_config` with range checks and logging).
5. `core/config_loader.py` `load_and_apply` calls `validate_config(yaml_data)` when `yaml_data` is truthy.
6. `core/__init__.py` exports `resolve_nested`, `validate_config`, protocol types (`GraphProtocol`, `ImageInProtocol`, `VoiceInProtocol`, `VoiceOutProtocol`); `GraphProtocol` is imported from `protocols` instead of `query_processor` to avoid duplicate binding.

Verified: `from BoggersTheAI.multimodal.base` and `from BoggersTheAI.core import resolve_nested` succeed when run from workspace root.
