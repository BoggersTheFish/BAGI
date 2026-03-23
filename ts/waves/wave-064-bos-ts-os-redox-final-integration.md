Wave 064 — bos-ts-os-redox-final-integration

**Propagate**
Activation: BOS-Full-OS Redox chain (kernel vendor, idle hook script, Orbital orbclient crate, overlay, config fragment, README, Podman build) converged to a single scripted path; TS = Thinking System (not TypeScript).

**Relax / Tension detected**
Tension: upstream Redox kernel layout drift (idle symbol names); lowest-stability node = automatic `fn idle` regex match — may require manual inject per `INJECT-POINTS.md`. Tension ~0.35.

**Break**
Collapsed assumption that a single static unified diff applies across all Redox commits — replaced with `apply-idle-hook.sh` + documented semantic diff in `patches/redox-kernel-ts-hook.diff`.

**Evolve**
Higher-stability config: `scripts/build-podman.sh` chains clone → overlay → kernel integration → idle hook → Podman; `bos-ts-orbital` (orbclient, φ graph, tension strip) + `recipes/bos-ts-shell/orbital.toml`; `config.toml` lists three packages for merge into upstream profile.

**Final stable configuration / Answer**
Delivered: `patches/redox-kernel-ts-hook.diff` (semantic + example), `scripts/apply-idle-hook.sh`, updated `apply-kernel-integration.sh` (Python `else:` fix), `scripts/build-podman.sh`, `crates/bos-ts-orbital` + `recipes/bos-ts-orbital`, `recipes/bos-ts-shell/orbital.toml`, expanded `config.toml`, README one-command flow. Bootable ISO path: run `./scripts/build-podman.sh` then `find redox -name '*.iso'`; QEMU: `qemu-system-x86_64 -m 2048 -cdrom <iso> -enable-kvm` or `cd redox && make run`. Merge `config.toml` `[packages]` into `redox/config/...` for your profile.
