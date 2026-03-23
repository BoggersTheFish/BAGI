#Requires -Version 5.1
# Clone or update Redox — TS = Thinking System (not TypeScript).
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$Redox = Join-Path $Root "redox"
if (Test-Path (Join-Path $Redox ".git")) {
    Write-Host "redox/ exists; git pull..."
    git -C $Redox pull --ff-only
} else {
    Write-Host "Cloning Redox into $Redox ..."
    git clone "https://gitlab.redox-os.org/redox-os/redox.git" $Redox
}
Write-Host "Done. Next: .\scripts\apply-overlay.ps1 then build per README (or .\scripts\setup-windows.ps1 once)."
