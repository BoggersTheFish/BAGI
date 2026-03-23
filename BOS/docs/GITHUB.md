# Publishing BOS to GitHub

> **Canonical repo:** the whole workspace is pushed as **`BAGI`** (one monorepo at the parent folder).  
> See **[`../../docs/GITHUB-BAGI.md`](../../docs/GITHUB-BAGI.md)** — do **not** use a separate `origin` only for `BOS/` unless you know you need a split.

## First-time setup (this folder only — legacy / subfolder workflow)

```bash
cd BOS
git init
git add -A
git status   # verify target/ is ignored
git commit -m "BOS: TS-OS host prototype (egui shell + kernel stubs)"
```

## Connect to GitHub

Create an empty repo (e.g. `BoggersTheFish/BOS`) **without** adding a README if you already have one locally.

```bash
git branch -M main
git remote add origin https://github.com/BoggersTheFish/BOS.git
git push -u origin main
```

Use SSH if you prefer: `git@github.com:BoggersTheFish/BOS.git`

## Updates

```bash
git add -A
git commit -m "Describe change"
git push
```

**TS** = Thinking System (not TypeScript).
