#Requires -Version 5.1
# Vendor bos-ts-kernel into Redox kernel recipe source (2026 layout). TS = Thinking System.
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\_copy_tree.ps1"
. "$PSScriptRoot\_ts_os_kernel_path.ps1"
$utf8 = New-Object System.Text.UTF8Encoding $false

$Root = Split-Path -Parent $PSScriptRoot
$Redox = Join-Path $Root "redox"

if (-not (Test-Path (Join-Path $Redox ".git"))) {
    Write-Error "ERROR: $Redox not found or not a git clone. Run clone-redox.ps1 first."
}

$K = Get-BosTsKernelRoot -RedoxRoot $Redox
if (-not $K) {
    Write-Error @"
ERROR: Could not find kernel Cargo.toml + src/. Tried:
  $Redox\recipes\core\kernel\source
  $Redox\cookbook\recipes\core\kernel\source
  $Redox\kernel
"@
}

Write-Host "Using kernel source: $K"

Write-Host "[1/4] copy bos-ts-kernel -> bos_ts_kernel"
$dest = Join-Path $K "bos_ts_kernel"
Copy-BosTreeSync -Source (Join-Path $Root "crates\bos-ts-kernel") -Destination $dest

Write-Host "[2/4] install bos_ts_idle.rs"
Copy-Item -Force (Join-Path $Root "patches\kernel-files\bos_ts_idle.rs") (Join-Path $K "src\bos_ts_idle.rs")

Write-Host "[3/4] patch kernel Cargo.toml"
$cargo = Join-Path $K "Cargo.toml"
$text = [System.IO.File]::ReadAllText($cargo)
if ($text -match "bos_ts_kernel") {
    Write-Host "  (bos_ts_kernel already in Cargo.toml)"
} else {
    if ($text -match "\[dependencies\]") {
        $text = [regex]::Replace($text, "(\[dependencies\]\r?\n)", "`$1bos_ts_kernel = { path = ""bos_ts_kernel"" }`n", 1)
    } else {
        $text += "`n[dependencies]`nbos_ts_kernel = { path = ""bos_ts_kernel"" }`n"
    }
    [System.IO.File]::WriteAllText($cargo, $text, $utf8)
    Write-Host "  appended bos_ts_kernel path dependency"
}

Write-Host "[4/4] insert mod bos_ts_idle in src/lib.rs"
$lib = Join-Path $K "src\lib.rs"
$lines = [System.IO.File]::ReadAllLines($lib)
$hasMod = $false
foreach ($ln in $lines) { if ($ln -match "mod bos_ts_idle") { $hasMod = $true; break } }
if ($hasMod) {
    Write-Host "  (mod bos_ts_idle already present)"
} else {
    $out = New-Object System.Collections.Generic.List[string]
    $inserted = $false
    foreach ($line in $lines) {
        [void]$out.Add($line)
        if (-not $inserted -and $line.StartsWith("#![no_std]")) {
            [void]$out.Add("mod bos_ts_idle;")
            $inserted = $true
        }
    }
    if (-not $inserted) {
        $out = @("mod bos_ts_idle;") + $lines
    }
    [System.IO.File]::WriteAllLines($lib, $out, $utf8)
    Write-Host "  inserted mod bos_ts_idle"
}

Write-Host ""
Write-Host "DONE. Next: apply-idle-hook.ps1"
