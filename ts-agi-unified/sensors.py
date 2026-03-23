"""
User input + optional hooks for vision/clock (stub — extend from BoggersBrain-style sensors).
"""
from __future__ import annotations

import hashlib
from typing import TYPE_CHECKING, Optional

import numpy as np

if TYPE_CHECKING:
    from graph import Node, UniversalLivingGraph


class UserInputSensor:
    def __init__(self, blend_weight: float = 0.3) -> None:
        self.last_input: str = ""
        self.blend_weight = blend_weight

    def get_input(self, prompt: str = "You: ") -> str:
        user_text = input(prompt).strip()
        self.last_input = user_text
        return user_text

    def inject_into_graph(self, graph: "UniversalLivingGraph", user_text: str) -> None:
        from graph import Node  # local import avoids cycles

        if "user" not in graph.nodes:
            graph.nodes["user"] = Node("user", user_text)
        else:
            graph.nodes["user"].content = user_text
        graph.nodes["user"].activation = 1.0

    def blend_into_sensor_vector(self, scalar_value: float) -> np.ndarray:
        h = int(hashlib.sha256(self.last_input.encode()).hexdigest()[:8], 16) % 10000
        blended = scalar_value * (1.0 - self.blend_weight) + (h / 10000.0) * self.blend_weight
        return np.array([blended], dtype=np.float64)


def optional_screen_grab_stub() -> Optional[bytes]:
    """Wire to PIL.ImageGrab when pillow is installed."""
    return None
