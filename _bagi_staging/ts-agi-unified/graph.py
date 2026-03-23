"""
TS wave graph — simplified Propagate → Relax → tension → Break/Evolve.
Inspired by GOAT-TS / BoggersTheAI patterns (not a verbatim copy of TS-Core).
"""
from __future__ import annotations

import json
import random
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Tuple

import numpy as np

EMBED_DIM = 384


@dataclass
class Node:
    id: str
    content: str
    activation: float = 0.5
    stability: float = 0.5
    base_strength: float = 0.5
    embedding: np.ndarray = field(default_factory=lambda: np.random.rand(EMBED_DIM).astype(np.float64))


class UniversalLivingGraph:
    def __init__(self, persistence_dir: Path | None = None) -> None:
        self.nodes: Dict[str, Node] = {}
        self.edges: Dict[str, List[Tuple[str, float, str]]] = {}
        self.tension: float = 0.20  # aligned with site / Wave 058 default
        self.wave_count: int = 0
        self._persist = persistence_dir or Path("persistence")
        self._persist.mkdir(parents=True, exist_ok=True)

    def add_edge(self, src: str, dst: str, weight: float = 0.5, relation: str = "rel") -> None:
        self.edges.setdefault(src, []).append((dst, weight, relation))

    def propagate(self) -> None:
        for nid, node in self.nodes.items():
            neighbors = self.edges.get(nid, [])
            if not neighbors:
                continue
            acc = 0.0
            wsum = 0.0
            for target_id, w, _ in neighbors:
                if target_id in self.nodes:
                    acc += self.nodes[target_id].activation * w
                    wsum += w
            if wsum > 0:
                avg = acc / wsum
                node.activation = float(np.clip(0.7 * node.activation + 0.3 * avg, 0.0, 1.0))

    def relax(self) -> None:
        for node in self.nodes.values():
            node.activation = float(
                np.clip(node.activation * 0.95 + node.base_strength * 0.05, 0.0, 1.0)
            )

    def detect_tension(self) -> float:
        if not self.nodes:
            return self.tension
        acts = [n.activation for n in self.nodes.values()]
        spread = float(abs(np.std(acts) - 0.1)) if len(acts) > 1 else 0.1
        return spread + self.tension * 0.5

    def break_and_evolve(self, tension_threshold: float) -> None:
        if self.detect_tension() <= tension_threshold:
            return
        if len(self.nodes) < 2:
            return
        protected = {"user", "self"}
        prunable = [n for n in self.nodes.values() if n.id not in protected]
        if not prunable:
            return
        weakest = min(prunable, key=lambda n: n.stability)
        del self.nodes[weakest.id]
        new_id = f"emergent_{self.wave_count}"
        self.nodes[new_id] = Node(new_id, "stabilized emergent concept")
        self.tension = float(np.clip(self.tension * 0.9, 0.0, 1.0))

    def run_wave(self, tension_threshold: float = 0.25) -> None:
        self.propagate()
        self.relax()
        self.break_and_evolve(tension_threshold)
        self.wave_count += 1
        self.tension = self.detect_tension()
        self._append_wave_history()

    def _append_wave_history(self) -> None:
        path = self._persist / "wave_history.jsonl"
        line = json.dumps(
            {
                "wave": self.wave_count,
                "tension": self.tension,
                "nodes": list(self.nodes.keys()),
            }
        )
        with path.open("a", encoding="utf-8") as fh:
            fh.write(line + "\n")
