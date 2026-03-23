# BAGI — single GitHub repository (whole workspace)

This **entire folder** (`BoggersTheWorkspace`) is one monorepo: **BAGI**.

**TS** = Thinking System / Thinking Wave (not TypeScript).

## What is tracked

- All projects under this root (`BOS/`, `BOS-Full-OS/`, `BoggersTheAI/`, `ts/`, …) **except** paths in the **root** `.gitignore` (build caches, `BOS-Full-OS/redox/` clone, etc.).

## First push

```bash
cd BoggersTheWorkspace   # this folder
git init                 # if not already
git add -A
git status
git commit -m "BAGI: full workspace snapshot"
git branch -M master
git remote add origin https://github.com/BoggersTheFish/BAGI.git
git push -u origin master
```

Replace `BoggersTheFish` with your GitHub user or org. Use SSH if you prefer: `git@github.com:BoggersTheFish/BAGI.git`

## After clone on another machine

```bash
git clone https://github.com/BoggersTheFish/BAGI.git
cd BAGI
# Redox tree (large) is not in git — recreate:
cd BOS-Full-OS && ./scripts/clone-redox.sh
```

## Nested repos

This monorepo uses **one** `.git` at the workspace root. Do not re-init git inside subfolders for the same tree.
