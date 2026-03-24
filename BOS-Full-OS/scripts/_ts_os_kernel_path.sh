#!/usr/bin/env bash
# Resolve Redox kernel crate root (2026: recipes/core/kernel/source). TS = Thinking System.
# Usage: source this file, then: K="$(bos_ts_kernel_root "$ROOT/redox")" || exit 1

bos_ts_kernel_root() {
  local R="${1:?redox root required}"
  local c
  for c in \
    "${R}/recipes/core/kernel/source" \
    "${R}/cookbook/recipes/core/kernel/source" \
    "${R}/kernel"
  do
    if [[ -f "${c}/Cargo.toml" && -d "${c}/src" ]]; then
      printf '%s' "$c"
      return 0
    fi
  done
  return 1
}
