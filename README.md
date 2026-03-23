# BAGI — Boggers workspace (Thinking System)

**TS** = **Thinking System / Thinking Wave** (not TypeScript). Optional web UI: [typescriptlang.org](https://www.typescriptlang.org/docs/).

This directory is the **BAGI** monorepo: **one Git repository** for the whole workspace. Push to GitHub repo **`BAGI`** (see [`docs/GITHUB-BAGI.md`](docs/GITHUB-BAGI.md)).

## What lives here (examples)

| Path | Role |
|------|------|
| [`BOS/`](BOS/) | Host/desktop TS prototype — egui shell + kernel stubs (`cargo run`) |
| [`BOS-Full-OS/`](BOS-Full-OS/) | Redox integration — `bos-ts-kernel`, recipes, kernel hook, Orbital (`bos-ts-orbital`) |
| [`BoggersTheAI/`](BoggersTheAI/) | AI / agent tooling |
| [`BoggersBrain/`](BoggersBrain/) | Brain / cognition experiments |
| [`ts/`](ts/) | Thinking System waves, `CURRENT-WAVE.txt` |

## TS-Powered Cursor

In Cursor Chat, prompts can drive `ts/waves/wave-*.md` traces and TS-OS loop output — your thinking history lives under `ts/waves/`.

## Git / GitHub

```bash
git add -A
git commit -m "Your message"
git push origin master
```

Remote: **`origin`** → `https://github.com/<you>/BAGI.git` (set once per [`docs/GITHUB-BAGI.md`](docs/GITHUB-BAGI.md)).

**Note:** `BOS-Full-OS/redox/` is **not** committed (large upstream clone). Use `BOS-Full-OS/scripts/clone-redox.sh` after clone.

## Links

- [boggersthefish.com](https://www.boggersthefish.com/)
- [GOAT-TS](https://github.com/BoggersTheFish/GOAT-TS)
