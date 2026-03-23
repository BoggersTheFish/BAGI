# BOS-Full-OS — mirror directory tree without rsync (TS = Thinking System, not TypeScript).
# Usage: Copy-BosTreeSync -Source "C:\src" -Destination "C:\dst"  # replaces dst with copy of src contents

function Copy-BosTreeSync {
    param(
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)][string]$Destination
    )
    if (-not (Test-Path -LiteralPath $Source)) {
        throw "Copy-BosTreeSync: source not found: $Source"
    }
    if (Test-Path -LiteralPath $Destination) {
        Remove-Item -LiteralPath $Destination -Recurse -Force
    }
    $null = New-Item -ItemType Directory -Force -Path $Destination
    Copy-Item -Path (Join-Path $Source '*') -Destination $Destination -Recurse -Force
}
