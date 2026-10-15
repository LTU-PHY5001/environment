# Shared PowerShell 5.1+ helpers. Dot-sourcing this file performs no installation.
Set-StrictMode -Version Latest

function Invoke-Checked {
    param([string]$Executable, [string[]]$Arguments)
    & $Executable @Arguments | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw "$Executable failed with exit code $LASTEXITCODE. Setup stopped; correct the error and rerun."
    }
}

function Get-VSCodeArchiveUri {
    param(
        [ValidatePattern('^(stable|\d+\.\d+\.\d+)$')]
        [string]$Version = 'stable'
    )
    # The update service uses "latest" for the release and "stable" for the channel.
    # https://code.visualstudio.com/docs/supporting/faq#_previous-release-versions
    $release = if ($Version -eq 'stable') { 'latest' } else { $Version }
    return "https://update.code.visualstudio.com/$release/win32-x64-archive/stable"
}

function Get-CachedDownload {
    param([string]$Uri, [string]$Destination)
    if ((Test-Path -LiteralPath $Destination) -and (Get-Item -LiteralPath $Destination).Length -gt 0) {
        Write-Host "Using cached download: $Destination"
        return
    }
    Write-Host "Downloading $Uri"
    $partial = "$Destination.partial"
    try {
        # Suppressing progress avoids the large PowerShell 5.1 download overhead.
        $savedProgress = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -UseBasicParsing -Uri $Uri -OutFile $partial
        if ((Get-Item -LiteralPath $partial).Length -eq 0) { throw "Empty download: $Uri" }
        Move-Item -LiteralPath $partial -Destination $Destination -Force
    } catch {
        throw "Download failed: $Uri`n$($_.Exception.Message)"
    } finally {
        $ProgressPreference = $savedProgress
        if (Test-Path -LiteralPath $partial) { Remove-Item -LiteralPath $partial -Force }
    }
}

function Invoke-SignedInstaller {
    param([string]$Installer, [string[]]$Arguments)
    $signature = Get-AuthenticodeSignature -FilePath $Installer
    if ($signature.Status -ne 'Valid') { throw "Invalid installer signature: $Installer ($($signature.Status))" }
    $process = Start-Process -FilePath $Installer -ArgumentList $Arguments -Wait -PassThru
    if ($process.ExitCode -notin @(0, 3010)) { throw "Installer failed with exit code $($process.ExitCode)." }
    if ($process.ExitCode -eq 3010) { Write-Warning 'Windows requests a restart after setup.' }
}
