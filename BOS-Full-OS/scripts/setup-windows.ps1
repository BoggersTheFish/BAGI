#Requires -Version 5.1
<#
.SYNOPSIS
  One-time Windows setup for BOS-Full-OS / TS-OS build helpers (Thinking System, not TypeScript).

.DESCRIPTION
  Auto-detects Python, Git, Git Bash, QEMU, Podman, WSL; suggests fixes; optional git long-paths.
  Run from repo root:  .\scripts\setup-windows.ps1
#>

$ErrorActionPreference = "Continue"
Write-Host "=== BOS-Full-OS — setup-windows.ps1 (TS = Thinking System) ===" -ForegroundColor Cyan

# --- Python ---
$py = $null
foreach ($cmd in @("python", "python3", "py")) {
    try {
        $v = & $cmd --version 2>&1
        if ($LASTEXITCODE -eq 0 -or $v -match "Python") {
            Write-Host "[OK] Python: $cmd — $v" -ForegroundColor Green
            $py = $cmd
            break
        }
    } catch { }
}
if (-not $py) {
    try {
        $v = & py -3 --version 2>&1
        Write-Host "[OK] Python: py -3 — $v" -ForegroundColor Green
        $py = "py -3"
    } catch {
        Write-Host "[!!] Python 3 not found. Install from https://www.python.org/downloads/ (check 'Add to PATH')." -ForegroundColor Yellow
    }
}

# --- Git ---
try {
    $gv = git --version 2>&1
    Write-Host "[OK] Git: $gv" -ForegroundColor Green
} catch {
    Write-Host "[!!] Git not in PATH. Install Git for Windows: https://git-scm.com/download/win" -ForegroundColor Yellow
}

# --- Git Bash (for upstream podman_build.sh) ---
$bash = $null
foreach ($p in @(
        "$env:ProgramFiles\Git\bin\bash.exe",
        "$env:ProgramFiles\Git\usr\bin\bash.exe",
        "${env:ProgramFiles(x86)}\Git\bin\bash.exe"
    )) {
    if (Test-Path -LiteralPath $p) {
        $bash = $p
        break
    }
}
if ($bash) {
    Write-Host "[OK] Git Bash: $bash" -ForegroundColor Green
} else {
    Write-Host "[!!] Git Bash not found (needed to run redox/podman_build.sh). Install Git for Windows." -ForegroundColor Yellow
}

# --- QEMU ---
$qemu = Get-Command qemu-system-x86_64.exe -ErrorAction SilentlyContinue
if (-not $qemu) { $qemu = Get-Command qemu-system-x86_64 -ErrorAction SilentlyContinue }
if ($qemu) {
    Write-Host "[OK] QEMU: $($qemu.Source)" -ForegroundColor Green
} else {
    $qpath = "C:\Program Files\qemu\qemu-system-x86_64.exe"
    if (Test-Path $qpath) {
        Write-Host "[!!] QEMU installed but not in PATH. Add: C:\Program Files\qemu" -ForegroundColor Yellow
    } else {
        Write-Host "[!!] qemu-system-x86_64 not found (optional for test-boot.ps1). https://www.qemu.org/download/#windows" -ForegroundColor Yellow
    }
}

# --- Podman ---
try {
    $pv = podman version 2>&1 | Select-Object -First 1
    Write-Host "[OK] Podman: $pv" -ForegroundColor Green
} catch {
    Write-Host "[!!] Podman not found. For full Redox builds use WSL2 + Podman per https://doc.redox-os.org/book/building-the-redox-os.html" -ForegroundColor Yellow
}

# --- WSL ---
$wsl = Get-Command wsl.exe -ErrorAction SilentlyContinue
if ($wsl) {
    Write-Host "[OK] WSL: $($wsl.Source) (optional; many users build Redox inside Ubuntu on WSL2)" -ForegroundColor Green
} else {
    Write-Host "[i] WSL not installed (optional). https://learn.microsoft.com/windows/wsl/install" -ForegroundColor DarkGray
}

# --- Execution policy (current user) ---
$pol = Get-ExecutionPolicy -Scope CurrentUser
Write-Host "[i] ExecutionPolicy (CurrentUser): $pol" -ForegroundColor DarkGray
if ($pol -eq "Restricted") {
    Write-Host "    Tip:  Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned" -ForegroundColor Yellow
}

# --- Git long paths (optional, reduces clone errors) ---
try {
    $lp = git config --global core.longpaths 2>$null
    if ($lp -ne "true") {
        Write-Host "[i] To enable long paths:  git config --global core.longpaths true" -ForegroundColor DarkGray
    }
} catch { }

Write-Host ""
Write-Host "Next (Windows-native PowerShell):" -ForegroundColor Cyan
Write-Host "  .\scripts\clone-redox.ps1"
Write-Host "  .\scripts\apply-overlay.ps1"
Write-Host "  .\scripts\apply-kernel-integration.ps1"
Write-Host "  .\scripts\apply-idle-hook.ps1"
Write-Host "  .\scripts\build-podman.ps1"
Write-Host "  .\scripts\test-boot.ps1"
Write-Host ""
Write-Host "Or use Git Bash / WSL with the .sh scripts (no rsync required)." -ForegroundColor DarkGray
