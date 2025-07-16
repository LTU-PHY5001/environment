## Powershell script for installing a portable instance of PYTHON on windows (10+).
## Using embedded linux. 
## Tested for python 3.13.0 on Windows 10
##
## G van Riessen, 2024-2025

#$mqitPath = "$($env:USERPROFILE)\mqit"
$currentDirectory = Get-Location
$mqitPath = "$currentDirectory\mqit"
$git_path = "$mqitPath\Git"
$gitBinPath = "$gitPath\bin"
$testPath = "$mqitPath\test"
$testScriptPath = "$testPath\testQ.ipynb"

# VS-Code variables
$minVersion = [Version]"1.100.0"
$vscodeurl =  "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive"

$venvPath = "$mqitPath\mqit-env\"
$activateEnvCmd = "$venvPath\Scripts\Activate.ps1"
$downloadPath =  "$mqitPath\VSCode.zip" 
$dataPath = "$mqitPath\VSCode\Data"
$codeExePath = "$mqitPath\VSCode\"
$codeExe = "$codeExePath\Code.exe"
$extensions = @("ms-python.python",
              "quantum.qsharp-lang-vscode",
              "ms-toolsai.jupyter")


$pythonVersion = "3.13.0" 
#$versionStr = ($pythonVersion -split '\.') -join ''
$versionStr = "313"
$pythonDownloadUrl = "https://www.python.org/ftp/python/$pythonVersion/python-$($pythonVersion)a5-embed-amd64.zip"
$pipDownloadURL = "https://bootstrap.pypa.io/get-pip.py"
$downloadPipPath = ".\get-pip.py"
#$installDir = "$mqitPath\python"
$downloadPythonPath =  "python-$($pythonVersion)a5-embed-amd64.zip"
$pythonPath =    "$mqitPath\python-$($pythonVersion)a5-embed-amd64"
$pythonExe = Join-Path $pythonPath "python.exe"
$pipPath = "$pythonPath\Scripts"
$pipExe = Join-Path $pipPath "pip.exe"
$confPath = "$pythonPath\python$versionStr._pth"

Write-Host " This script will install portable instances of PYTHON, VS-Code and Git to ${mqitPath}." -ForegroundColor Yellow


# create directory if not exists
if (!(test-path $mqitPath))
{
    New-Item -ItemType Directory $mqitPath
}
# create directory if not exists
if (!(test-path $venvPath))
{
    New-Item -ItemType Directory $venvPath
}



# install embedded python:

Set-Location $mqitPath

# Download Python installer 
Write-Host " Downloading python installer to $downloadPythonPath"
Invoke-WebRequest -Uri $pythonDownloadUrl -OutFile $downloadPythonPath

# Expand the archive, remove if already exists
if (test-path $pythonPath) {
    Write-Host " Removing existing python installation at $pythonPath"
    Remove-Item -Path $pythonPath -Recurse -Force
}
Write-Host " Expanding python archive to $pythonPath"
Expand-Archive -Path $downloadPythonPath -Force
Write-Host ("   Expanded python archive to $pythonPath, removing archive file $downloadPythonPath")
Remove-Item $downloadPythonPath -Force

Set-Location $currentDirectory

# Set path
$PATH = [Environment]::GetEnvironmentVariable("PATH")
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$pythonPath;$pythonPath\Scripts")

# install pip
Write-Host " Installing pip for python $pythonVersion in $pythonPath"
Set-Location $mqitPath
Invoke-WebRequest -Uri $pipDownloadURL -OutFile $downloadPipPath
& $pythonExe  get-pip.py
Remove-Item $downloadPipPath -Force

# fix PIP module path
# Ensure the target file exists
if (-Not (Test-Path $confPath)) {
    Write-Error "File not found: $confPath"
    exit 1
}

# Append "Lib/site-packages" to the file
Add-Content -Path $confPath -Value "Lib/site-packages"

Write-Host "Appended 'Lib/site-packages' to $path"

# create virtual environment (python)
Write-Host " Creating virtual environment in $venvPath"
& $pythonExe -m pip install --no-cache virtualenv --no-warn-script-location
& $pythonExe -m virtualenv $venvPath

# Activate new virtual environment (save wd, activate change back to saved wd)  --- too fragile in powershell 
#Write-Host " Activating virtual environment $venvPath"
#& $activateEnvCmd

# Instead of activating the environment, we will use the python executable directly:
# Define the path to the venv's python
$venvPython = Join-Path $envPath "Scripts\python.exe"


# install python packages
Set-Location $currentDirectory
Write-Host " Installing python packages from requirements.txt in $currentDirectory"
& $venvPython -m pip install --no-cache -r "$($currentDirectory)/requirements.txt"

# create a python kUUernel
Write-Host " Creating a python kernel for Jupyter notebooks in $venvPath"
& $venvPython -m ipykernel install --user --name=mqit_kernel 

Write-Host " Python installation Complete.  Run python $pythonVersion from the path $pythonPath."
Write-Host " Use python virtual environment mqit-env."


Set-Location $currentDirectory

# Now Install Git in current directory 

# append git path to git.inf 
Add-Content -Path "git.inf" -Value "Dir=$($git_path)"

# get and install Git
Write-Host " Downloading GIT installer ..." -ForegroundColor Yellow
curl -o "./GitInstall.exe" "https://github.com/git-for-windows/git/releases/download/v2.46.0.windows.1/Git-2.46.0-64-bit.exe"

Write-Host " Installing GIT at ${gitPath}.." -ForegroundColor Yellow
./GitInstall.exe /SP- /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /LOADINF="git.inf"

Write-Host " Updating Path..." -ForegroundColor Yellow

# Add git CLI utilities to path
$PATH = [Environment]::GetEnvironmentVariable("PATH")
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$gitBinPath")


# Now install VS-code
Write-Host " Installing portable instance of VS Code..."

# Get VS Code archive (zip file), expand it.
Write-Host " Downloading VS-Code from $vscodeurl..." -ForegroundColor Yellow
& curl -o $downloadPath $vscodeurl
cd $mqitPath
Expand-Archive -Path $downloadPath

#Make Data folder to store configuration
New-Item -ItemType Directory $dataPath

# Add VS-Code to path
$PATH = [Environment]::GetEnvironmentVariable("PATH")
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$codeExePath")


Remove-item $downloadPath

# install IQ# (note that it happens automatically when using Conda, not pip or via Code extensions)
#first switch to mqit-env virtual environment
#& $activateEnvCmd
#dotnet tool install -g Microsoft.Quantum.IQSharp
#dotnet iqsharp install --user

Set-Location $currentDirectory

# Install any extensions
#foreach ($extension in $extensions) {
#    Write-Host "`nInstalling extension $extension..." -ForegroundColor Yellow
#    & $codeExe --install-extension $extension --force
#}
# or: $codeExe --install-extension ms-python.python quantum.qsharp-lang-vscode ms-toolsai.jupyter --force
#** check https://stackoverflow.com/questions/40080793/is-there-a-way-to-change-the-extensions-folder-location-for-visual-studio-code


#force reload of path without restartig powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

& $activateEnvCmd


# Attempt to install VS-Code extntions python, jupyter and qsharp
#foreach ($extension in $extensions) {
#    Write-Host "`nInstalling extension $extension..." -ForegroundColor Yellow
#    & $codeExe --install-extension $extension --force
#}

Write-Host " VS-Code installed at $codeExePath.  You can start it with  with $codeExe." -ForegroundColor Yellow

Set-Location $currentDirectory

& $codeExe --folder-uri "file://$testPath" --user-data-dir $testPath
Write-Host " VS-Code started, opening test folder $testPath." -ForegroundColor Yellow
Write-Host " Installation complete.  You can now use the portable instance of PYTHON, VS-Code and GIT in $mqitPath." -ForegroundColor Green
Write-Host " To use the virtual environment, run the command: & $activateEnvCmd" -ForegroundColor Green
Write-Host " To run the test notebook, run the command: & $codeExe --folder-uri 'file://$testPath' --user-data-dir $testPath" -ForegroundColor Green



