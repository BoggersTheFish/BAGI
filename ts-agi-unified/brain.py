"""
Bridge: `UniversalLivingGraph` (GOAT-style conversation layer) + vendored
`closed_loop_control.ControlSystem` (BoggersBrain 4-node substrate).

`ControlSystem` owns its own internal `Graph` (16-D vectors); we do not replace it.
User text is written to ``external_event.txt`` (scalar) so ``read_external_event_vec`` blends it.
"""
from __future__ import annotations

from pathlib import Path
from typing import TYPE_CHECKING

from closed_loop_control import ControlSystem

if TYPE_CHECKING:
    from graph import UniversalLivingGraph

_ROOT = Path(__file__).resolve().parent
_EXTERNAL = _ROOT / "external_event.txt"


class TsAgiBrain:
    """Thin wrapper: file-based user injection + ``wave_step`` + ULG tension sync."""

    def __init__(self) -> None:
        self.cs = ControlSystem()

    def inject_user_sensor(self, user_text: str) -> None:
        """Drive Phase-5 external sensor (bounded scalar in 0..100 scale)."""
        val = float((hash(user_text) % 10000)) / 100.0
        _EXTERNAL.parent.mkdir(parents=True, exist_ok=True)
        _EXTERNAL.write_text(f"{val}\n", encoding="utf-8")

    def wave_step(self) -> None:
        self.cs.wave_step()

    def sync_ulg_tension(self, ulg: "UniversalLivingGraph") -> None:
        hist = self.cs.graph.tension_history
        if not hist:
            return
        t = float(hist[-1])
        # Map unbounded internal tension to [0,1] for the conversational graph meter
        blended = t / (t + 1.0) if t >= 0 else 0.0
        ulg.tension = float(max(0.0, min(1.0, 0.5 * ulg.tension + 0.5 * blended)))


def create_control_system() -> TsAgiBrain:
    return TsAgiBrain()
