#Requires -Version 5.1
# One-shot BOS build: overlay + kernel + idle hook + upstream podman_build (TS = Thinking System).
# Steps 1–3b are native PowerShell; Redox upstream podman_build.sh still runs under Git Bash or WSL.
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

function Find-GitBash {
    foreach ($p in @(
            "$env:ProgramFiles\Git\bin\bash.exe",
            "$env:ProgramFiles\Git\usr\bin\bash.exe",
            "${env:ProgramFiles(x86)}\Git\bin\bash.exe"
        )) {
        if (Test-Path -LiteralPath $p) { return $p }
    }
    $cmd = Get-Command bash.exe -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    return $null
}

Write-Host "=== [1/6] clone Redox (if missing) ===" -ForegroundColor Cyan
$Redox = Join-Path $Root "redox"
if (-not (Test-Path (Join-Path $Redox ".git"))) {
    & "$PSScriptRoot\clone-redox.ps1"
} else {
    Write-Host "redox/ exists, skipping clone."
}

Write-Host "=== [2/6] cookbook overlay ===" -ForegroundColor Cyan
& "$PSScriptRoot\apply-overlay.ps1"

Write-Host "=== [3/6] kernel TS integration ===" -ForegroundColor Cyan
& "$PSScriptRoot\apply-kernel-integration.ps1"

Write-Host "=== [3b/6] idle hook ===" -ForegroundColor Cyan
& "$PSScriptRoot\apply-idle-hook.ps1"
if ($LASTEXITCODE -ne 0) {
    Write-Warning "apply-idle-hook.ps1 failed — add hook manually (patches/INJECT-POINTS.md)"
}

Write-Host "=== [4/6] Podman build (upstream Redox — requires bash) ===" -ForegroundColor Cyan
$bash = Find-GitBash
$podmanSh = Join-Path $Redox "podman_build.sh"
$boot = Join-Path $Redox "podman-bootstrap.sh"
if (-not (Test-Path $podmanSh) -and (Test-Path $boot)) { $podmanSh = $boot }

if (-not (Test-Path $podmanSh)) {
    Write-Error "No podman_build.sh — see https://doc.redox-os.org/book/building-the-redox-os.html"
}

$argLine = $args -join ' '
if ($bash) {
    $cd = $Redox -replace '\\', '/'
    $sh = Split-Path $podmanSh -Leaf
    & $bash -lc "cd '$cd' && ./$sh $argLine"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} elseif (Get-Command wsl.exe -ErrorAction SilentlyContinue) {
    $wslPath = wsl wslpath -a $Redox 2>$null
    if (-not $wslPath) {
        Write-Error "Could not map path to WSL. Install Git for Windows (bash) or fix wslpath."
    }
    wsl bash -lc "cd `"$wslPath`" && ./$(Split-Path $podmanSh -Leaf) $argLine"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} else {
    Write-Error "Need Git Bash (bash.exe) or WSL to run $($podmanSh). Run setup-windows.ps1 for diagnostics."
}

Write-Host ""
Write-Host "=== [5/6] locate bootable image ===" -ForegroundColor Cyan
Set-Location $Redox
$iso = Get-ChildItem -Path . -Recurse -Include "*.iso", "live.iso", "redox.iso" -File -ErrorAction SilentlyContinue | Select-Object -First 1
if ($iso) {
    Write-Host "Found image: $($iso.FullName)"
    Write-Host "QEMU: qemu-system-x86_64 -m 2048 -cdrom `"$($iso.FullName)`""
    Write-Host "Or: cd redox; make run"
} else {
    Write-Host "ISO not found under redox/ — search build/ per upstream docs."
}

Write-Host ""
if ($env:SKIP_BOOT_TEST -eq "1") {
    Write-Host "=== [6/6] boot test SKIPPED (SKIP_BOOT_TEST=1) ===" -ForegroundColor Yellow
} else {
    Write-Host "=== [6/6] boot verification ===" -ForegroundColor Cyan
    & "$PSScriptRoot\test-boot.ps1"
    $tb = $LASTEXITCODE
    if ($tb -ne 0) {
        Write-Warning "test-boot.ps1 failed — set SKIP_BOOT_TEST=1 to skip, or REQUIRE_BOOT_TEST=1 to fail hard."
        if ($env:REQUIRE_BOOT_TEST -eq "1") { exit 1 }
    }
}
