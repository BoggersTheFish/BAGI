# Publishing BOS-Full-OS to GitHub

> **Canonical repo:** the whole workspace is pushed as **`BAGI`** (one monorepo at the parent folder).  
> See **[`../../docs/GITHUB-BAGI.md`](../../docs/GITHUB-BAGI.md)**.

## What gets committed (when BOS-Full-OS was its own repo — legacy)

- `crates/`, `recipes/`, `scripts/`, `patches/`, `docs/`, `config.toml`, `Cargo.toml`, `README.md`, etc.
- **`redox/` is ignored** (see `.gitignore`) — it is a separate clone of [gitlab.redox-os.org/redox-os/redox](https://gitlab.redox-os.org/redox-os/redox). Do not commit the full Redox tree.

## First-time setup

```bash
cd BOS-Full-OS
git init
git add -A
git status   # confirm redox/ and target/ are not listed
git commit -m "BOS-Full-OS: TS-OS Redox integration (kernel + recipes + scripts)"
```

## Connect to GitHub

Create an empty repo (e.g. `BoggersTheFish/BOS-Full-OS`).

```bash
git branch -M main
git remote add origin https://github.com/BoggersTheFish/BOS-Full-OS.git
git push -u origin main
```

SSH: `git@github.com:BoggersTheFish/BOS-Full-OS.git`

## After clone on another machine

```bash
git clone https://github.com/BoggersTheFish/BOS-Full-OS.git
cd BOS-Full-OS
./scripts/clone-redox.sh   # or clone-redox.ps1 — recreates redox/
```

## Updates

```bash
git add -A
git commit -m "Describe change"
git push
```

**TS** = Thinking System (not TypeScript).
