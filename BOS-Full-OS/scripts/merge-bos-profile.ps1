# Phase 1: merge BOS-Full-OS [packages] into the Redox desktop profile (idempotent).
# Set $env:REDOX_PROFILE to override. TS = Thinking System (not TypeScript).
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Redox = Join-Path $Root "redox"
$Py = Join-Path $Root "scripts\merge_bos_into_redox_profile.py"

if (-not (Test-Path $Py)) {
    Write-Error "Missing $Py"
    exit 1
}

$profile = $env:REDOX_PROFILE
if (-not $profile) {
    $candidates = @(
        (Join-Path $Redox "config\x86_64\desktop.toml"),
        (Join-Path $Redox "config\x86_64\demo.toml"),
        (Join-Path $Redox "config\desktop.toml")
    )
    foreach ($c in $candidates) {
        if (Test-Path -LiteralPath $c) {
            $profile = $c
            break
        }
    }
}

if (-not $profile -or -not (Test-Path -LiteralPath $profile)) {
    Write-Host "No Redox profile found under redox/config — skip merge. Clone Redox or set REDOX_PROFILE."
    exit 0
}

$python = $null
foreach ($name in @("python3", "python", "py")) {
    try { $python = Get-Command $name -ErrorAction Stop; break } catch { }
}
if (-not $python) {
    Write-Error "python3 not found — install Python 3.11+ or merge config.toml by hand."
    exit 1
}

& $python.Source $Py $profile
exit $LASTEXITCODE
