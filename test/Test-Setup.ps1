# Runs without Windows installation, downloads or administrator privileges.
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/../Setup.Common.ps1"
$tempFolder = Join-Path ([IO.Path]::GetTempPath()) ([Guid]::NewGuid().ToString())
New-Item -ItemType Directory $tempFolder | Out-Null
$runtime = (Get-Process -Id $PID).Path
try {
    Invoke-Checked $runtime @('-NoProfile', '-Command', 'exit 0')
    $failed = $false
    try { Invoke-Checked $runtime @('-NoProfile', '-Command', 'exit 9') } catch { $failed = $true }
    if (-not $failed) { throw 'Nonzero native exit code was ignored.' }

    $script:downloadCalls = 0
    function Invoke-WebRequest {
        param([switch]$UseBasicParsing, [string]$Uri, [string]$OutFile)
        $script:downloadCalls++
        Set-Content -LiteralPath $OutFile -Value 'downloaded'
    }
    $destination = Join-Path $tempFolder 'archive.zip'
    Get-CachedDownload 'https://example.invalid/file' $destination
    Get-CachedDownload 'https://example.invalid/file' $destination
    if ($script:downloadCalls -ne 1) { throw 'Valid cached file was downloaded twice.' }
    if (Test-Path "$destination.partial") { throw 'Partial file left after successful download.' }

    function Invoke-WebRequest {
        param([switch]$UseBasicParsing, [string]$Uri, [string]$OutFile)
        Set-Content -LiteralPath $OutFile -Value 'partial'
        throw 'Simulated network failure'
    }
    $destination = Join-Path $tempFolder 'failed.zip'
    $failed = $false
    try { Get-CachedDownload 'https://example.invalid/file' $destination } catch { $failed = $true }
    if (-not $failed) { throw 'Network failure was ignored.' }
    if ((Test-Path $destination) -or (Test-Path "$destination.partial")) { throw 'Failed download was retained as usable.' }

    foreach ($file in Get-ChildItem "$PSScriptRoot/.." -Filter '*.ps1' -Recurse) {
        $tokens = $null; $errors = $null
        $null = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$errors)
        if ($errors.Count) { throw "PowerShell parse failure in $($file.Name): $errors" }
    }
    Write-Host 'PASS: native exit checks, download caching, partial cleanup and PowerShell syntax.'
} finally {
    Remove-Item -LiteralPath $tempFolder -Recurse -Force
}
