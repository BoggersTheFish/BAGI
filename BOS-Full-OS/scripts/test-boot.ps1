#Requires -Version 5.1
# QEMU boot test: capture serial, grep TS_IDLE_TICK_RUNNING (TS = Thinking System).
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Redox = Join-Path $Root "redox"
$Marker = "TS_IDLE_TICK_RUNNING"
$LogDir = Join-Path $Root "target"
$Log = Join-Path $LogDir "ts-boot-serial.log"
$TimeoutSec = if ($env:TEST_BOOT_SECONDS) { [int]$env:TEST_BOOT_SECONDS } else { 10 }

function Find-Qemu {
    $c = Get-Command "qemu-system-x86_64.exe" -ErrorAction SilentlyContinue
    if ($c) { return $c.Source }
    $c = Get-Command "qemu-system-x86_64" -ErrorAction SilentlyContinue
    if ($c) { return $c.Source }
    $p = "C:\Program Files\qemu\qemu-system-x86_64.exe"
    if (Test-Path $p) { return $p }
    return $null
}

$qemu = Find-Qemu
if (-not $qemu) {
    Write-Error "qemu-system-x86_64 not found in PATH or Program Files\qemu."
}

$iso = Get-ChildItem -Path $Redox -Recurse -Include "*.iso", "live.iso", "redox.iso" -File -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $iso) {
    Write-Error "No bootable .iso under $Redox. Run build-podman.ps1 first."
}

$null = New-Item -ItemType Directory -Force -Path $LogDir
Remove-Item -LiteralPath $Log -ErrorAction SilentlyContinue

Write-Host "test-boot: ISO=$($iso.FullName)"
Write-Host "test-boot: serial log -> $Log (wait ${TimeoutSec}s)"

$logQemu = $Log -replace '\\', '/'
$p = Start-Process -FilePath $qemu -ArgumentList @(
    "-m", "2048",
    "-cdrom", $iso.FullName,
    "-serial", "file:$logQemu",
    "-display", "none",
    "-no-reboot",
    "-monitor", "none"
) -PassThru -WindowStyle Hidden

Start-Sleep -Seconds $TimeoutSec
if (-not $p.HasExited) {
    Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
}

if (Test-Path $Log) {
    $txt = Get-Content -LiteralPath $Log -Raw -ErrorAction SilentlyContinue
    if ($txt -and $txt.Contains($Marker)) {
        Write-Host "SUCCESS: found $Marker in serial capture (kernel idle hook active)." -ForegroundColor Green
        exit 0
    }
}

Write-Host "FAIL: $Marker not found in $Log after ${TimeoutSec}s." -ForegroundColor Red
if (Test-Path $Log) {
    Write-Host "---- tail log ----"
    Get-Content $Log -Tail 80 -ErrorAction SilentlyContinue
}
exit 1
