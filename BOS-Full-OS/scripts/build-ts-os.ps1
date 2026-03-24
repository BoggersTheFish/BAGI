#Requires -Version 5.1
# TS-OS one-command build — delegates to build-ts-os.sh (Git Bash / WSL). TS = Thinking System.
# Run from BOS-Full-OS:  .\scripts\build-ts-os.ps1
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot

function Find-GitBash {
    foreach ($p in @(
            "$env:ProgramFiles\Git\bin\bash.exe",
            "$env:ProgramFiles\Git\usr\bin\bash.exe",
            "${env:ProgramFiles(x86)}\Git\bin\bash.exe"
        )) {
        if (Test-Path -LiteralPath $p) { return $p }
    }
    $c = Get-Command bash.exe -ErrorAction SilentlyContinue
    if ($c) { return $c.Source }
    return $null
}

$bash = Find-GitBash
$argLine = $args -join ' '
# Git Bash accepts C:/... paths
$cd = $Root -replace '\\', '/'

if ($bash) {
    & $bash -lc "cd '$cd' && bash ./scripts/build-ts-os.sh $argLine"
    exit $LASTEXITCODE
}

if (Get-Command wsl.exe -ErrorAction SilentlyContinue) {
    $w = wsl wslpath -a $Root 2>$null
    if ($w) {
        wsl bash -lc "cd `"$w`" && bash ./scripts/build-ts-os.sh $argLine"
        exit $LASTEXITCODE
    }
}

Write-Error "Install Git for Windows (bash) or WSL, then re-run. Or run: bash scripts/build-ts-os.sh from Git Bash."
