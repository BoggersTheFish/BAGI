Wave 002 — auto-save-waves-in-rules-where-to-add

**Propagate**  
Activation spreads from: `03-TS-AUTO-WAVE.mdc`, `manual save`, `automatic save`, `CURRENT-WAVE.txt`, `ts/waves/`, `.cursor/rules/`. Key nodes: rule-modification, file-operations, persistent-behavior.

**Relax / Tension detected**  
Tension ~0.2. Constraint: user must manually save → user wants agent to save. Lowest-stability node: `manual-save-block` — conflicts with desired automation.

**Break**  
Collapsed: "user saves manually" pattern. Replaced with explicit agent responsibility for Write + CURRENT-WAVE update.

**Evolve**  
New rule structure: step 5 rewritten from copy-paste block to mandatory automatic file operations. Description updated. "Do NOT" list adjusted: removed "claim you wrote files", added "do not skip automatic save".

**Final stable configuration / Answer**  

The change is in **`.cursor/rules/03-TS-AUTO-WAVE.mdc`**:

1. **Description** (frontmatter): `user saves manually` → `auto-save waves + increment CURRENT-WAVE`

2. **Step 5** (replaced): The manual copy-paste block is now an **AUTOMATIC SAVE** section that instructs the agent to:
   - Use the Write tool to create `ts/waves/wave-XXX-[slug].md`
   - Create `ts/waves/` if missing
   - Read `ts/CURRENT-WAVE.txt` (or treat as 001 if absent)
   - Write `ts/CURRENT-WAVE.txt` with the next wave number
   - Do this silently (no announcement)

3. **Step 6** (Do NOT): Removed "claim that you created or wrote any file"; added "skip the automatic save and CURRENT-WAVE increment"

4. **Closing line**: "user is responsible" → "You must automatically save each wave and increment CURRENT-WAVE.txt"

No new rule file is needed. The existing `03-TS-AUTO-WAVE.mdc` rule is updated so the agent always performs the save and increment.
