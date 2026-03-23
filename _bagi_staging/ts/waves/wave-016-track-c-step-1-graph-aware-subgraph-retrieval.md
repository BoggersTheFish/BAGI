Wave 016 — track-c-step-1-graph-aware-subgraph-retrieval

**Propagate** 
Activation spread from synthesis requirements into graph retrieval API (`get_activated_subgraph`) and query processor context orchestration.

**Relax / Tension detected** 
Primary tension was replacing naive topic retrieval while keeping existing response flow/backward compatibility. Resolved by graph-subgraph-first with fallback.

**Break** (if applicable) 
Collapsed naive context-only retrieval as the primary source.

**Evolve** 
Synthesis now receives activated subgraph context from the living graph with debug visibility (`context_nodes`, `activation_scores`).

**Final stable configuration / Answer** 
Track C Step 1 implemented: graph-aware subgraph retrieval is now wired through `QueryProcessor` and runtime config.
