# Resolve Redox kernel crate root (2026: recipes/core/kernel/source). TS = Thinking System.
function Get-BosTsKernelRoot {
    param(
        [Parameter(Mandatory)][string]$RedoxRoot
    )
    $candidates = @(
        (Join-Path $RedoxRoot "recipes\core\kernel\source"),
        (Join-Path $RedoxRoot "cookbook\recipes\core\kernel\source"),
        (Join-Path $RedoxRoot "kernel")
    )
    foreach ($c in $candidates) {
        $cargo = Join-Path $c "Cargo.toml"
        $src = Join-Path $c "src"
        if ((Test-Path -LiteralPath $cargo) -and (Test-Path -LiteralPath $src)) {
            return $c
        }
    }
    return $null
}
