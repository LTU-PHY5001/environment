# Windows x64, PowerShell 5.1+. Installs under this script's folder, not the caller's folder.
[CmdletBinding()]
param(
    [switch]$IncludeWorkshopTools,
    [switch]$NoLaunch,
    [string]$VSCodeVersion = 'stable'
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
. "$PSScriptRoot\Setup.Common.ps1"
if ($env:OS -ne 'Windows_NT') { throw 'This course installer supports Windows x64 only.' }
$architecture = $env:PROCESSOR_ARCHITECTURE
if ($env:PROCESSOR_ARCHITEW6432) { $architecture = $env:PROCESSOR_ARCHITEW6432 }
if ($architecture -ne 'AMD64') { throw 'Use a course Windows x64 machine; this bundle is not validated for ARM/32-bit Windows.' }
if ($VSCodeVersion -notmatch '^(stable|\d+\.\d+\.\d+)$') { throw 'VSCodeVersion must be stable or a version such as 1.100.3.' }
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$mqitPath = Join-Path $PSScriptRoot 'mqit'
$cachePath = Join-Path $mqitPath 'cache'
$pythonVersion = '3.12.9'
$pythonPath = Join-Path $mqitPath "python-$pythonVersion-embed-amd64"
$pythonExe = Join-Path $pythonPath 'python.exe'
$venvPath = Join-Path $mqitPath 'mqit-env'
$venvPython = Join-Path $venvPath 'Scripts\python.exe'
$gitPath = Join-Path $mqitPath 'Git'
$gitExe = Join-Path $gitPath 'cmd\git.exe'
$codePath = Join-Path $mqitPath 'VSCode'
$codeExe = Join-Path $codePath 'Code.exe'
$codeCli = Join-Path $codePath 'bin\code.cmd'
$testPath = Join-Path $PSScriptRoot 'test'
$env:PIP_CACHE_DIR = Join-Path $cachePath 'pip'
$env:PIP_DISABLE_PIP_VERSION_CHECK = '1'
New-Item -ItemType Directory -Path $mqitPath, $cachePath -Force | Out-Null

$setupStep = 'Python installation'
try {
    if (-not (Test-Path -LiteralPath $pythonExe)) {
        $archive = Join-Path $cachePath "python-$pythonVersion-embed-amd64.zip"
        Get-CachedDownload "https://www.python.org/ftp/python/$pythonVersion/python-$pythonVersion-embed-amd64.zip" $archive
        Expand-Archive -LiteralPath $archive -DestinationPath $pythonPath -Force
    }
    # Embedded Python ships with isolated sys.path and site disabled. Enable site
    # before bootstrapping pip/virtualenv; do not append duplicate entries on reruns.
    $pth = Join-Path $pythonPath 'python312._pth'
    $lines = @(Get-Content -LiteralPath $pth)
    $lines = @($lines | ForEach-Object { if ($_ -match '^#\s*import site\s*$') { 'import site' } else { $_ } })
    if ($lines -notcontains 'Lib\site-packages') { $lines += 'Lib\site-packages' }
    Set-Content -LiteralPath $pth -Value $lines -Encoding ASCII
    Invoke-Checked $pythonExe @('--version')

    $setupStep = 'Python virtual environment'
    if (-not (Test-Path -LiteralPath $venvPython)) {
        # Bootstrap only once. Keep pip caching enabled; do not re-download every package.
        $bootstrap = Join-Path $cachePath 'get-pip.py'
        Get-CachedDownload 'https://bootstrap.pypa.io/get-pip.py' $bootstrap
        Invoke-Checked $pythonExe @($bootstrap, 'pip==25.3')
        Invoke-Checked $pythonExe @('-m', 'pip', 'install', 'virtualenv==20.35.4')
        Invoke-Checked $pythonExe @('-m', 'virtualenv', '--no-periodic-update', $venvPath)
    }
    $setupStep = 'Python packages'
    Invoke-Checked $venvPython @('-m', 'pip', 'install', '--only-binary=:all:', '-r', "$PSScriptRoot\requirements.txt")
    if ($IncludeWorkshopTools) {
        Invoke-Checked $venvPython @('-m', 'pip', 'install', '-r', "$PSScriptRoot\requirements-workshops.txt")
    }
    Invoke-Checked $venvPython @('-m', 'pip', 'check')
    # A package install completing is insufficient: run the Q# and Python smoke test.
    $setupStep = 'Python/QDK smoke test'
    Invoke-Checked $venvPython @("$testPath\smoke_test.py")
    $setupStep = 'Jupyter kernel registration'
    Invoke-Checked $venvPython @('-m', 'ipykernel', 'install', '--user', '--name=mqit_kernel', '--display-name=MQIT (Python 3.12)')

    $setupStep = 'Git installation'
    if (-not (Test-Path -LiteralPath $gitExe)) {
        $installer = Join-Path $cachePath 'GitInstall.exe'
        if (-not (Test-Path -LiteralPath $installer)) {
            $headers = @{ 'User-Agent' = 'LTU-PHY5001-Setup'; 'Accept' = 'application/vnd.github+json' }
            $release = Get-RemoteJson -Uri 'https://api.github.com/repos/git-for-windows/git/releases/latest' -Headers $headers
            $assets = @($release.assets | Where-Object { $_.name -match '^Git-[\d.]+-64-bit\.exe$' })
            if ($assets.Count -ne 1) { throw 'Cannot identify the official Git x64 installer.' }
            Get-CachedDownload $assets[0].browser_download_url $installer
        }
        Invoke-SignedInstaller $installer @('/SP-', '/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART', '/CURRENTUSER',
            "/DIR=`"$gitPath`"", "/LOADINF=`"$PSScriptRoot\git.inf`"")
    }
    Invoke-Checked $gitExe @('--version')

    $setupStep = 'VS Code installation'
    Write-Host 'Preparing portable VS Code...'
    if (-not (Test-Path -LiteralPath $codeExe)) {
        $archive = Join-Path $cachePath "VSCode-$VSCodeVersion.zip"
        $codeUri = Get-VSCodeArchiveUri -Version $VSCodeVersion
        Get-CachedDownload $codeUri $archive
        Expand-Archive -LiteralPath $archive -DestinationPath $codePath -Force
    }
    New-Item -ItemType Directory -Path "$codePath\data" -Force | Out-Null
    Invoke-Checked $codeCli @('--version')
    $setupStep = 'VS Code extension installation'
    $installedExtensions = @(& $codeCli --list-extensions)
    if ($LASTEXITCODE -ne 0) { throw 'Could not list portable VS Code extensions.' }
    foreach ($extension in @('ms-python.python', 'ms-toolsai.jupyter', 'quantum.qsharp-lang-vscode')) {
        if ($installedExtensions -notcontains $extension) {
            Invoke-Checked $codeCli @('--install-extension', $extension)
        }
    }

    $setupStep = 'Recording installed versions'
    # Persist the actual resolved environment for staff. No package is silently skipped.
    $resolved = @(& $venvPython -m pip freeze)
    if ($LASTEXITCODE -ne 0) { throw 'Could not record installed packages.' }
    Set-Content -LiteralPath "$mqitPath\requirements.installed.txt" -Value $resolved -Encoding UTF8
    $codeDetails = @(& $codeCli --version)
    if ($LASTEXITCODE -ne 0) { throw 'Could not record VS Code version.' }
    $gitDetails = @(& $gitExe --version)
    if ($LASTEXITCODE -ne 0) { throw 'Could not record Git version.' }
    $extensionDetails = @(& $codeCli --list-extensions --show-versions)
    if ($LASTEXITCODE -ne 0) { throw 'Could not record extension versions.' }
    @{
        installedAt = (Get-Date).ToString('o'); python = $pythonVersion
        git = $gitDetails; vscode = $codeDetails; extensions = $extensionDetails
        requirementsSHA256 = (Get-FileHash "$PSScriptRoot\requirements.txt" -Algorithm SHA256).Hash
        workshopTools = [bool]$IncludeWorkshopTools
    } | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath "$mqitPath\installation.json" -Encoding UTF8

    # Session PATH only: launch.ps1 restores it each time, without changing system Python.
    $env:Path = "$gitPath\cmd;$venvPath\Scripts;$env:Path"
    Write-Host 'Setup checks passed. Open test/testQ.ipynb and verify the widget in VS Code.' -ForegroundColor Green
    Write-Host "Select kernel: MQIT (Python 3.12). Launch future sessions with $PSScriptRoot\launch.ps1"
    $setupStep = 'Launching VS Code'
    if (-not $NoLaunch) { & "$PSScriptRoot\launch.ps1" -Folder $testPath }
} catch {
    Write-Error "SETUP FAILED during ${setupStep}: $($_.Exception.Message)" -ErrorAction Continue
    Write-Host 'Fix the reported problem and rerun install.ps1. Existing files and download cache are retained.'
    exit 1
}
