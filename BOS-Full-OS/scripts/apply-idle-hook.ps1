#Requires -Version 5.1
# Insert TS idle hook — kernel path from _ts_os_kernel_path.ps1
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\_ts_os_kernel_path.ps1"

$Root = Split-Path -Parent $PSScriptRoot
$Redox = Join-Path $Root "redox"
$K = Get-BosTsKernelRoot -RedoxRoot $Redox
if (-not $K) {
    Write-Error "Kernel source not found — run apply-kernel-integration.ps1 first."
}
$KernelSrc = Join-Path $K "src"
if (-not (Test-Path $KernelSrc)) {
    Write-Error "Missing $KernelSrc"
}

$python = $null
$pyExtra = $null
foreach ($cmd in @("python", "python3")) {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        $python = $cmd
        break
    }
}
if (-not $python -and (Get-Command py -ErrorAction SilentlyContinue)) {
    $python = "py"
    $pyExtra = @("-3")
}
if (-not $python) {
    Write-Error "Python 3 required for apply-idle-hook.ps1."
}

$pyFile = Join-Path $env:TEMP "bos-apply-idle-$(Get-Random).py"
$pyCode = @'
import re
import sys
from pathlib import Path

kernel_src = Path(sys.argv[1])
HOOK = """    unsafe {
        crate::bos_ts_idle::ts_kernel_idle_hook();
    }
"""
prefer = ("scheduler", "context", "cpu", "idle")
candidates = sorted(
    kernel_src.rglob("*.rs"),
    key=lambda p: (
        0 if any(x in str(p).lower() for x in prefer) else 1,
        len(str(p)),
    ),
)

patched = None
for path in candidates:
    text = path.read_text(encoding="utf-8")
    if "ts_kernel_idle_hook" in text:
        print(f"Already patched: {path}")
        raise SystemExit(0)
    patterns = [
        r"(pub\s+)?fn\s+idle\s*\([^)]*\)\s*(?:->\s*[^{]+)?\{",
        r"(pub\s+)?fn\s+idle_loop\s*\([^)]*\)\s*(?:->\s*[^{]+)?\{",
    ]
    m = None
    for pat in patterns:
        m = re.search(pat, text)
        if m:
            break
    if m:
        insert_at = m.end()
        new_text = text[:insert_at] + "\n" + HOOK + text[insert_at:]
        path.write_text(new_text, encoding="utf-8")
        patched = path
        break

if patched is None:
    print(
        "ERROR: could not find `fn idle(...)` under kernel source.\n"
        "Add manually (see patches/INJECT-POINTS.md)."
    )
    raise SystemExit(1)

print(f"Inserted idle hook in: {patched}")
'@

Set-Content -LiteralPath $pyFile -Value $pyCode -Encoding UTF8
try {
    if ($pyExtra) {
        & $python @pyExtra $pyFile $KernelSrc
    } else {
        & $python $pyFile $KernelSrc
    }
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} finally {
    Remove-Item -LiteralPath $pyFile -ErrorAction SilentlyContinue
}
