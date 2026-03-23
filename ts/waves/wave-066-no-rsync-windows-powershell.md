Wave 066 — no-rsync-windows-powershell

**Propagate**
Activation: removed all `rsync` from BOS-Full-OS `scripts/*.sh` (replaced with `rm -rf` + `mkdir -p` + `cp -R`); added `_copy_tree.ps1`, `setup-windows.ps1`, and full PowerShell ports (`apply-overlay.ps1`, `apply-kernel-integration.ps1`, `apply-idle-hook.ps1`, `build-podman.ps1`, `test-boot.ps1`, updated `clone-redox.ps1`); README Windows section. TS = Thinking System (not TypeScript).

**Relax / Tension detected**
Tension ~0.2: upstream `redox/` tree may still reference rsync in third-party recipes — out of scope for BOS scripts. `podman_build.sh` still requires Git Bash or WSL.

**Break**
Collapsed dependency on MSYS2 `rsync` for Git Bash users.

**Evolve**
Windows-native path: `.\scripts\setup-windows.ps1` once, then `.ps1` pipeline; shared `Copy-BosTreeSync` mirrors `rsync --delete` semantics.

**Final stable configuration / Answer**
Delivered: no rsync in project scripts; `cp -R`/PowerShell `Copy-Item` only; full `.ps1` suite + `setup-windows.ps1`; README table and setup callout.
