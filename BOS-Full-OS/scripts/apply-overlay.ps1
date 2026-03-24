#Requires -Version 5.1
# Copy BOS recipes into redox/cookbook/recipes — no rsync (TS = Thinking System).
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\_copy_tree.ps1"

$Root = Split-Path -Parent $PSScriptRoot
$Redox = Join-Path $Root "redox"
$Cook = Join-Path $Redox "cookbook\recipes"

if (-not (Test-Path (Join-Path $Redox ".git"))) {
    Write-Error "Run scripts\clone-redox.ps1 first."
}

$null = New-Item -ItemType Directory -Force -Path $Cook

foreach ($r in @("bos-ts-kernel", "bos-ts-shell", "bos-ts-orbital", "bos-ts-installer", "bos-ts-updater", "bos-ts-graphd")) {
    Write-Host "Copying recipe $r..."
    $dest = Join-Path $Cook $r
    if (Test-Path $dest) { Remove-Item -LiteralPath $dest -Recurse -Force }
    Copy-Item -Path (Join-Path $Root "recipes\$r") -Destination $dest -Recurse -Force
}

Write-Host "Syncing bos-ts-kernel into bos-ts-orbital recipe (path dep)..."
$orbKernel = Join-Path $Cook "bos-ts-orbital\source\bos-ts-kernel"
Copy-BosTreeSync -Source (Join-Path $Root "crates\bos-ts-kernel") -Destination $orbKernel

Write-Host "Syncing bos-ts-orbital sources..."
$orbSrc = Join-Path $Cook "bos-ts-orbital\source\src"
Copy-BosTreeSync -Source (Join-Path $Root "crates\bos-ts-orbital\src") -Destination $orbSrc

Write-Host "Recipes installed under $Cook"
Write-Host "Optional: sync bos-ts-kernel recipe with cp -R (see apply-overlay.sh echo)."
