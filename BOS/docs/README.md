# BOS — documentation index

**TS** = Thinking System / Thinking Wave (not TypeScript). See the [main README](../README.md).

| Doc | Purpose |
|-----|---------|
| [../README.md](../README.md) | Project overview, build (`cargo run -p bos-shell`), roadmap, literature links |
| [GITHUB.md](GITHUB.md) | Initialize git, add remote, push to GitHub |

## Related repository

- **[BOS-Full-OS](https://github.com/BoggersTheFish/BOS-Full-OS)** — Redox integration: `bos-ts-kernel`, Orbital shell, kernel idle hook, Podman build scripts. This **BOS** repo is the lighter **host/desktop egui** prototype; **BOS-Full-OS** is the **bootable OS integration** layer.

## Crates (quick reference)

| Crate | Path | Role |
|-------|------|------|
| `bos-kernel` | `kernel/` | TS idle tick stubs (Propagate / Relax / tension) |
| `bos-shell` | `bos-shell/` | egui desktop — tension panel, portal placeholder |
