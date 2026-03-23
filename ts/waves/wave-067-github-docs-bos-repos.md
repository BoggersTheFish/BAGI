Wave 067 — github-docs-bos-repos

**Propagate**
Documentation indexes (`docs/README.md`), GitHub publish guides (`docs/GITHUB.md`), README cross-links between BOS and BOS-Full-OS (GitHub URLs), `.gitignore` tweaks; `git init` + initial commit on `main` in both repos.

**Relax / Tension detected**
Tension: actual `git push` requires remote + credentials — not executed; user runs `git remote add` + `git push` per docs.

**Break**
N/A.

**Evolve**
Stable doc surface: each repo self-describes + points to sibling; BOS-Full-OS documents `redox/` exclusion.

**Final stable configuration / Answer**
BOS and BOS-Full-OS are git repos with commits; push with `git remote add origin https://github.com/BoggersTheFish/<repo>.git` then `git push -u origin main`.
