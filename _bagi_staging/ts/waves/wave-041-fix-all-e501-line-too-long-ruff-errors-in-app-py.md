Wave 041 — fix-all-e501-line-too-long-ruff-errors-in-app-py

**Propagate**
Activation spread to `BoggersTheAI/dashboard/app.py`, ruff E501 (88 char limit), triple-quoted HTML/JS/CSS strings, and TS wave save nodes.

**Relax / Tension detected**
Constraint: every Python source line ≤88 chars. Eight lines in embedded wave + graph viz strings violated; duplicate cookie-parse pattern required disambiguated edits.

**Break** (if applicable)
Collapsed monolithic JS regex lines, single-line CSS `#details` block, long `#info` HTML, cytoscape selector/layout objects, and one-line `if` in tap handler.

**Evolve**
Split `document.cookie.replace` into multi-line calls in both endpoints; expanded `#details` CSS to one property per line; wrapped `#info` div across lines; broke collapsed-node selector and cose layout into multi-line objects; wrapped `details` hide `if` with braces.

**Final stable configuration / Answer**
All eight E501 issues in `app.py` are fixed via `StrReplace`: long lines are broken inside the embedded HTML/CSS/JS while preserving behavior. `ruff check --select E501` on that file passes (exit 0).
