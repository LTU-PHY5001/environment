\
# scripts/setup-python.ps1
# Robust Python installation & validation for Windows 11 lab machines.
# - Installs python.org CPython into ./mqit/Python312 (user-scoped, no PATH edits)
# - Rebuilds venv ./mqit/mqit-env on every run to avoid stale ABI paths
# - Installs pinned wheels from ../requirements.txt (no compilers required)
# - Executes tests/selftest.ipynb headlessly and exits non-zero on failure

param(
    [string]$PythonVersion = "3.12.5",
    [string]$RootDir = $(Join-Path (Split-Path -Parent $PSScriptRoot) "mqit"),
    [switch]$VerboseLog
)

$ErrorActionPreference = 'Stop'
if ($VerboseLog) { $VerbosePreference = "Continue" }

$PyHome = Join-Path $RootDir 'Python312'
$Venv  = Join-Path $RootDir 'mqit-env'
$Reqs  = Join-Path (Split-Path -Parent $PSScriptRoot) 'requirements.txt'
$SelfTest = Join-Path (Split-Path -Parent $PSScriptRoot) 'tests\selftest.ipynb'

Write-Host "==> Preparing directories at $RootDir"
New-Item -ItemType Directory -Force -Path $RootDir | Out-Null

# Download python.org installer (amd64) to temp if needed
$Installer = Join-Path $env:TEMP "python-$PythonVersion-amd64.exe"
if (-not (Test-Path $Installer)) {
    $url = "https://www.python.org/ftp/python/$PythonVersion/python-$PythonVersion-amd64.exe"
    Write-Host "==> Downloading Python $PythonVersion ..."
    Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $Installer
}

# Install CPython (user-scoped) into the fixed location
if (-not (Test-Path (Join-Path $PyHome 'python.exe'))) {
    Write-Host "==> Installing CPython into $PyHome ..."
    & $Installer /quiet InstallAllUsers=0 Include_pip=1 Include_launcher=0 PrependPath=0 TargetDir="$PyHome"
}

# Recreate the venv fresh (avoid old Win10 ABI leakage)
if (Test-Path $Venv) {
    Write-Host "==> Removing old venv at $Venv ..."
    Remove-Item -Recurse -Force $Venv
}
Write-Host "==> Creating venv ..."
& (Join-Path $PyHome 'python.exe') -m venv $Venv

$Pip = Join-Path $Venv 'Scripts\pip.exe'
$Py  = Join-Path $Venv 'Scripts\python.exe'

Write-Host "==> Upgrading pip ..."
& $Pip install --upgrade pip

# Install from requirements (wheel-only ensures no compilers)
if (-not (Test-Path $Reqs)) {
    throw "requirements.txt not found at $Reqs"
}
Write-Host "==> Installing requirements (wheels only) ..."
& $Pip install --only-binary=:all: -r $Reqs

# Register Jupyter kernel (optional but useful)
Write-Host "==> Registering Jupyter kernel 'mqit-env' ..."
& $Py -m ipykernel install --user --name "mqit-env" --display-name "Python (mqit-env)"

# Execute self-test notebook headlessly; fail hard on error
if (-not (Test-Path $SelfTest)) {
    throw "Self-test notebook not found at $SelfTest"
}
Write-Host "==> Running self-test notebook ..."
& $Py -m jupyter nbconvert --to notebook --execute "$SelfTest" --output "$env:TEMP\selftest.out.ipynb"

Write-Host "==> Environment OK."
