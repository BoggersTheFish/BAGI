Wave 049 — implement-two-performance-optimizations-boggers

**Propagate**
Activation: consolidation O(n²) pairs, universal_living_graph get_activated_subgraph full sort; constraints: preserve ConsolidationResult API, heapq.nlargest for top-k fill.

**Relax / Tension detected**
Low tension; pair enumeration and global ranking paths identified.

**Break**
(none)

**Evolve**
Topic-bucketed pair generation with index-ordered dedupe; nlargest(needed, pool, key) for global top-up; import heapq.

**Final stable configuration / Answer**
- `consolidation.py`: Candidates are grouped into `topic_buckets` (topic → nodes); only unordered pairs drawn from the same bucket are considered (shared topic), deduped by sorted id pair, then sorted by `(ia, ib)` to match former nested-loop order. Merge loop uses the same threshold and `_absorb` behavior. `_jaccard` iterates the smaller token set against the larger set, returns `0.0` when `intersection == 0`, and uses `|A|+|B|-intersection` for union. Removed unused `_share_topic`.
- `universal_living_graph.py`: `import heapq`; global fill uses `needed = top_k - len(candidates)`, `pool` = non-collapsed nodes not already in `seen_ids`, `heapq.nlargest(needed, pool, key=_rank_key)` (same tuple key as before), then append. O(n log k) for fixed `top_k`.
