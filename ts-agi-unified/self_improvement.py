"""
QLoRA / trace → Alpaca pipeline (Wave 059+).

Use BoggersTheAI ``core/fine_tuner.py`` + traces when you have GPU and data.
Optional: ``ollama create ts-native-14b -f Modelfile`` after a trained adapter exists.
"""
from __future__ import annotations

import os
import sys
from pathlib import Path


def run_qlora_stub() -> int:
    """Placeholder: wire to BoggersTheAI or unsloth CLI."""
    repo = os.environ.get("BOGGERS_THE_AI_ROOT", "")
    if not repo or not Path(repo).is_dir():
        print(
            "Set BOGGERS_THE_AI_ROOT to a checkout of BoggersTheAI, "
            "or run training from that repo directly.",
            file=sys.stderr,
        )
        return 1
    print("QLoRA stub: invoke BoggersTheAI fine_tuner from:", repo)
    return 0


if __name__ == "__main__":
    raise SystemExit(run_qlora_stub())
