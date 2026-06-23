## Powershell script for removing the portable MQIT development environment.
##
## G van Riessen, 2024-2025

param (
    [switch]$Force
)

$currentDirectory = Get-Location
$mqitPath = "$currentDirectory\mqit"
$pythonVersion = "3.12.9"
$pythonPath = "$mqitPath\python-$($pythonVersion)-embed-amd64"
$gitPath = "$mqitPath\Git"
$codeExePath = "$mqitPath\VSCode\"
$kernelSpecPath = Join-Path $env:APPDATA "jupyter\kernels\mqit_kernel"
$gitInstallerPath = Join-Path $currentDirectory "GitInstall.exe"

function Remove-PathEntries {
    param (
        [Parameter(Mandatory=$true)]
        [System.EnvironmentVariableTarget]$Target,

        [Parameter(Mandatory=$true)]
        [string[]]$EntriesToRemove
    )

    try {
        $pathValue = [Environment]::GetEnvironmentVariable("Path", $Target)
        if (-not $pathValue) {
            return
        }

        $normalizedEntries = $EntriesToRemove | ForEach-Object {
            $_.Trim().TrimEnd("\")
        }

        $keptEntries = $pathValue -split ";" | Where-Object {
            $entry = $_.Trim()
            if (-not $entry) {
                $false
            } else {
                $normalizedEntry = $entry.TrimEnd("\")
                -not ($normalizedEntries -contains $normalizedEntry)
            }
        }

        $newPathValue = ($keptEntries -join ";")
        if ($newPathValue -ne $pathValue) {
            [Environment]::SetEnvironmentVariable("Path", $newPathValue, $Target)
            Write-Host " Removed MQIT entries from $Target Path."
        }
    } catch {
        Write-Warning " Could not update $Target Path: $($_.Exception.Message)"
    }
}

Write-Host " This script will remove the portable MQIT development environment from $mqitPath." -ForegroundColor Yellow

if (-not $Force) {
    $confirm = Read-Host "Remove MQIT Python, VS Code, Git, generated files, and the mqit_kernel Jupyter kernelspec? (Y/N)"
    if ($confirm -notmatch '^[Yy]$') {
        Write-Host " Uninstall cancelled."
        exit 0
    }
}

$pathEntriesToRemove = @(
    $pythonPath,
    "$pythonPath\Scripts",
    "$gitPath\bin",
    "$gitPath\cmd",
    "$gitPath\usr\bin",
    $codeExePath
)

Remove-PathEntries -Target ([System.EnvironmentVariableTarget]::Process) -EntriesToRemove $pathEntriesToRemove
Remove-PathEntries -Target ([System.EnvironmentVariableTarget]::User) -EntriesToRemove $pathEntriesToRemove
Remove-PathEntries -Target ([System.EnvironmentVariableTarget]::Machine) -EntriesToRemove $pathEntriesToRemove

if (Test-Path $kernelSpecPath) {
    Write-Host " Removing Jupyter kernel spec at $kernelSpecPath"
    Remove-Item -Path $kernelSpecPath -Recurse -Force
}

if (Test-Path $gitInstallerPath) {
    Write-Host " Removing Git installer at $gitInstallerPath"
    Remove-Item -Path $gitInstallerPath -Force
}

if (Test-Path $mqitPath) {
    Write-Host " Removing MQIT environment at $mqitPath"
    Remove-Item -Path $mqitPath -Recurse -Force
} else {
    Write-Host " No MQIT environment found at $mqitPath"
}

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host " Uninstall complete." -ForegroundColor Green
