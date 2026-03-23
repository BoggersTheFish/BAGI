# Publishing BOS to GitHub

## First-time setup (this folder only)

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
