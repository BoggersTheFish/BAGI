Wave 033 — implement-observability-ux-polish-cli-commands

**Propagate**
Activation spread from dashboard/app.py → mind/tui.py → interface/chat.py. Key active nodes: graph visualization (sigma.js), TUI rich panels, metrics endpoint, CLI introspection commands. Cross-links between /graph data endpoint and /graph/viz consumer. Runtime.get_metrics() propagates as shared dependency across TUI + dashboard + CLI.

**Relax / Tension detected**
Tension ~0.3. Lowest-stability node: the old _render function in tui.py used Path for trace counting but the new version delegates metrics to runtime.graph.get_metrics() — leftover import created a minor inconsistency. The old chat.py had minimal commands with no graph introspection — high tension between available runtime capabilities and exposed CLI surface.

**Break**
Collapsed the old minimal _render and flat chat.py patterns. Removed unused Path import from tui.py. Replaced thin CLI with full command vocabulary.

**Evolve**
New stable structure across three files:
- dashboard/app.py: /graph/viz (sigma.js interactive viz) + /metrics (stability trend, graph+wave combined)
- mind/tui.py: rich grid layout with metrics table + top-5 activated nodes with bars + recent events panel
- interface/chat.py: 9 CLI commands (status, graph stats, trace show, wave pause/resume, improve, history, help, exit)

**Final stable configuration / Answer**
All four tasks implemented:

**5A — /graph/viz**: Added interactive sigma.js graph visualization endpoint. Fetches from /graph, renders nodes colored by stability (cyan >0.7, red otherwise, grey if collapsed), sized by activation. Click-to-inspect detail panel.

**5B — Expanded TUI**: _render now uses Table.grid layout with two columns: left = metrics table (cycle, tension, nodes active/total, edges, avg activation/stability, edge density), right = top-5 activated nodes with unicode bar charts. Bottom row = recent events panel. Removed unused Path import.

**5C — /metrics endpoint**: Returns combined graph metrics, wave status, stability trend (inverse of last 50 tension values), and tension history length. Auth-gated via Depends(_check_auth).

**5D — CLI commands**: Rewrote chat.py with help, status, graph stats (with top topics), trace show, wave pause/resume, improve (self-improvement trigger), and history commands. All fallthrough to rt.ask() for natural language queries.
