Wave 018 — track-c-step-3-consistency-and-trace-hooks

**Propagate** 
Activation spread into synthesis validation and post-synthesis trace hooks.

**Relax / Tension detected** 
Main tension was adding self-improvement logging without disrupting fallback synthesis behavior.

**Break** (if applicable) 
Collapsed stub-only consistency checks.

**Evolve** 
Hypotheses are now validated against context nodes/topics and traces are logged conditionally by confidence.

**Final stable configuration / Answer** 
Track C Step 3 implemented:
- full hypothesis consistency checks
- supporting node linkage
- conditional reasoning trace logging to `traces/reasoning_*.jsonl`
- config-driven self-improvement settings and runtime traces dir creation
