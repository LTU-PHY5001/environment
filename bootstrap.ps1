#Requires -Version 5.1
# Downloads the complete published installer and runs it from a permanent folder.
[CmdletBinding()]
param(
    [string]$DestinationPath = (Join-Path $env:LOCALAPPDATA 'MQIT')
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$partial = $null
$extractionFolder = $null
try {
    if ($env:OS -ne 'Windows_NT') { throw 'This course installer supports Windows x64 only.' }
    $curl = Get-Command curl.exe -CommandType Application -ErrorAction SilentlyContinue
    if (-not $curl) { throw 'Windows curl.exe is unavailable. Ask teaching staff or IT to restore it.' }
    New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null
    $DestinationPath = (Resolve-Path -LiteralPath $DestinationPath).Path
    $archive = Join-Path $DestinationPath 'MQIT-Portable.zip'
    $partial = "$archive.partial"
    $releaseUri = 'https://github.com/LTU-PHY5001/environment/releases/download/MQIT-Portable/MQIT-Portable.zip'

    Write-Host 'Downloading the MQIT course installer...'
    & $curl.Source --fail --location --silent --show-error --retry 3 --output $partial $releaseUri
    if ($LASTEXITCODE -ne 0) { throw "Download failed (curl exit code $LASTEXITCODE): $releaseUri" }
    if ((Get-Item -LiteralPath $partial).Length -eq 0) { throw 'The downloaded installer ZIP is empty.' }
    Move-Item -LiteralPath $partial -Destination $archive -Force
    Write-Host "Extracting the installer into $DestinationPath..."
    $extractionFolder = Join-Path $DestinationPath ('.mqit-extract-' + [Guid]::NewGuid().ToString())
    Expand-Archive -LiteralPath $archive -DestinationPath $extractionFolder -Force
    $extractedInstallerFolder = Join-Path $extractionFolder 'MQIT-Portable'
    if (-not (Test-Path -LiteralPath (Join-Path $extractedInstallerFolder 'install.ps1') -PathType Leaf)) {
        throw 'The release ZIP does not contain MQIT-Portable/install.ps1.'
    }
    $installerFolder = Join-Path $DestinationPath 'MQIT-Portable'
    New-Item -ItemType Directory -Path $installerFolder -Force | Out-Null
    Get-ChildItem -LiteralPath $extractedInstallerFolder -Force | Copy-Item -Destination $installerFolder -Recurse -Force
    $installer = Join-Path $installerFolder 'install.ps1'

    Write-Host "Installing MQIT from $installerFolder..."
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $installer
    if ($LASTEXITCODE -ne 0) { throw "The course installer failed (exit code $LASTEXITCODE). Correct the reported error and rerun." }
} catch {
    Write-Error "MQIT bootstrap failed: $($_.Exception.Message)" -ErrorAction Continue
    exit 1
} finally {
    if ($partial -and (Test-Path -LiteralPath $partial)) { Remove-Item -LiteralPath $partial -Force }
    if ($extractionFolder -and (Test-Path -LiteralPath $extractionFolder)) { Remove-Item -LiteralPath $extractionFolder -Recurse -Force }
}
