"""
TS-AGI unified v0.2 — conversational loop: ULG wave + BoggersBrain closed loop + Ollama.

Order: inject user → GOAT-style ``run_wave`` on ``UniversalLivingGraph`` →
``ControlSystem.wave_step`` (vendored) → sync tension → LLM after settlement.
"""
from __future__ import annotations

import os
import time
from pathlib import Path

try:
    from dotenv import load_dotenv

    load_dotenv()
except ImportError:
    pass

from brain import TsAgiBrain, create_control_system
from graph import Node, UniversalLivingGraph
from sensors import UserInputSensor

try:
    import ollama
except ImportError:
    ollama = None  # type: ignore


def main() -> None:
    base = Path(__file__).resolve().parent
    graph = UniversalLivingGraph(persistence_dir=base / "persistence")
    sensor = UserInputSensor()
    brain: TsAgiBrain = create_control_system()

    graph.nodes["user"] = Node("user", "human conversation partner")
    graph.nodes["self"] = Node("self", "TS-AGI core")
    graph.add_edge("user", "self", 0.6, "dialogue")
    graph.add_edge("self", "user", 0.6, "dialogue")

    wave_interval = float(os.environ.get("WAVE_INTERVAL_SECONDS", "0.5"))
    tension_threshold = float(os.environ.get("TENSION_THRESHOLD", "0.25"))
    model = os.environ.get("OLLAMA_MODEL", "llama3.2")

    print("TS-AGI unified v0.2 — type 'quit' to exit")
    print(f"  ULG tension≈{graph.tension:.3f} | ollama model={model}")
    print("  (Vendored closed_loop_control.py in this folder — BoggersBrain)")

    while True:
        user_text = sensor.get_input()
        if user_text.lower() in ("quit", "exit", "q"):
            break

        sensor.inject_into_graph(graph, user_text)
        brain.inject_user_sensor(user_text)

        graph.run_wave(tension_threshold=tension_threshold)
        brain.wave_step()
        brain.sync_ulg_tension(graph)

        context = " | ".join(
            n.content for n in graph.nodes.values() if n.activation > 0.4
        )
        if ollama is None:
            print(
                "AGI: (pip install ollama + running server) — context:",
                context[:240],
            )
        else:
            try:
                response = ollama.chat(
                    model=model,
                    messages=[
                        {
                            "role": "system",
                            "content": "You are a TS-OS assistant: concise, graph-grounded.",
                        },
                        {
                            "role": "user",
                            "content": (
                                f"User said: {user_text}\n"
                                f"Graph settled. Respond meaningfully. Context: {context[:4000]}"
                            ),
                        },
                    ],
                )
                msg = response.get("message", {}) or {}
                print("AGI:", msg.get("content", response))
            except Exception as e:
                print("AGI: (ollama error)", e, "— context:", context[:200])

        time.sleep(wave_interval)


if __name__ == "__main__":
    main()
