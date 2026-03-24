#Requires -Version 5.1
# Legacy — delegates to build-ts-os.ps1 (TS = Thinking System).
$ErrorActionPreference = "Stop"
& "$PSScriptRoot\build-ts-os.ps1" @args
exit $LASTEXITCODE
