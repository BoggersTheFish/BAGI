#!/usr/bin/env python3
"""
Merge BOS-Full-OS config.toml [packages] into a Redox image profile TOML (idempotent).
TS = Thinking System (not TypeScript). Safe for typical [packages] sections only.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

MARKER = "# --- BOS-Full-OS merged packages (do not edit by hand; use scripts/merge-bos-profile.*) ---"


def load_bos_package_names(config_path: Path) -> list[str]:
    import tomllib

    data = tomllib.loads(config_path.read_text(encoding="utf-8-sig"))
    pkgs = data.get("packages")
    if not isinstance(pkgs, dict):
        return []
    return sorted(pkgs.keys())


def existing_package_names_in_section(lines: list[str], start: int, end: int) -> set[str]:
    names: set[str] = set()
    pat = re.compile(r"^([A-Za-z0-9_-]+)\s*=")
    for j in range(start, end):
        s = lines[j].strip()
        if not s or s.startswith("#"):
            continue
        m = pat.match(s)
        if m:
            names.add(m.group(1))
    return names


def find_packages_section(lines: list[str]) -> tuple[int, int] | None:
    """Return [start, end) line indices for lines inside [packages] (exclusive of [packages] line)."""
    i = 0
    n = len(lines)
    while i < n:
        if lines[i].strip() == "[packages]":
            start = i + 1
            j = start
            while j < n:
                t = lines[j].strip()
                if t.startswith("[") and t != "[packages]":
                    return (start, j)
                j += 1
            return (start, n)
        i += 1
    return None


def merge_packages_into_text(text: str, package_names: list[str]) -> tuple[str, bool]:
    """Insert missing package lines before the next section after [packages]. Returns (new_text, changed)."""
    if not package_names:
        return text, False

    lines = text.splitlines(keepends=True)
    sec = find_packages_section(lines)
    if sec is None:
        # Append new [packages] block at EOF
        add = []
        if not text.endswith("\n") and text:
            add.append("\n")
        add.append("\n[packages]\n")
        if MARKER not in text:
            add.append(MARKER + "\n")
        for name in package_names:
            add.append(f"{name} = {{}}\n")
        return text + "".join(add), True

    start, end = sec
    existing = existing_package_names_in_section(lines, start, end)
    missing = [p for p in package_names if p not in existing]
    if not missing:
        return text, False

    insert_at = end
    block: list[str] = []
    if MARKER not in "".join(lines[start:end]):
        block.append(MARKER + "\n")
    for name in missing:
        block.append(f"{name} = {{}}\n")

    new_lines = lines[:insert_at] + block + lines[insert_at:]
    return "".join(new_lines), True


def main() -> int:
    root = Path(__file__).resolve().parent.parent
    config = root / "config.toml"
    if len(sys.argv) < 2:
        print("Usage: merge_bos_into_redox_profile.py <path-to-redox-profile.toml>", file=sys.stderr)
        return 2

    profile = Path(sys.argv[1]).resolve()
    if not config.is_file():
        print(f"Missing {config}", file=sys.stderr)
        return 1
    if not profile.is_file():
        print(f"Profile not found: {profile}", file=sys.stderr)
        return 1

    names = load_bos_package_names(config)
    if not names:
        print("No [packages] keys in BOS-Full-OS config.toml", file=sys.stderr)
        return 1

    # utf-8-sig strips BOM so "[packages]" matches after PowerShell Set-Content / Windows editors
    text = profile.read_text(encoding="utf-8-sig")
    new_text, changed = merge_packages_into_text(text, names)
    if not changed:
        print(f"BOS packages already present in {profile} — nothing to do.")
        return 0

    profile.write_text(new_text, encoding="utf-8", newline="\n")
    print(f"Merged BOS packages into {profile}: {', '.join(names)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
