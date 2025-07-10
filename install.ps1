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
$pythonDownloadUrl = "https://www.python.org/ftp/python/$pythonVersion/python-$($pythonVersion)a5-embed-amd64.zip"
$pipDownloadURL = "https://bootstrap.pypa.io/get-pip.py"
$downloadPipPath = ".\get-pip.py"
#$installDir = "$mqitPath\python"
$downloadPythonPath =  "python-$($pythonVersion)a5-embed-amd64.zip"
$pythonPath =    "$mqitPath\python-$($pythonVersion)a5-embed-amd64"
$pythonExe = Join-Path $pythonPath "python.exe"



Write-Host "`n This script will install portable instances of PYTHON, VS-Code and Git to ${mqitPath}."



Write-Host "`n Getting ready to install  portable instance of PYTHON to ${mqitPath}..."

# create directory if not exists
if (!(test-path $mqitPath))
{
    New-Item -ItemType Directory $mqitPath
}

# install embedded python:

Set-Location $mqitPath

# Download Python installer 
Write-Host "`n Downloading python installer to $downloadPythonPath"
Invoke-WebRequest -Uri $pythonDownloadUrl -OutFile $downloadPythonPath

Expand-Archive -Path $downloadPythonPath
Remove-Item $downloadPythonPath -Force

Set-Location $currentDirectory


# Set path
$PATH = [Environment]::GetEnvironmentVariable("PATH")
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$pythonPath")

# install pip
Set-Location $mqitPath
Invoke-WebRequest -Uri $pipDownloadURL -OutFile $downloadPipPath

$pythonExe  get-pip.py

# create virtual environment (python)
pip install --no-cache virtualenv
$pythonExe -m venv "$mqitPath\mqit-env"

# Activate new virtual environment (save wd, activate change back to saved wd)
Set-Location "$mqitPath\mqit-env\Scripts\"
./Activate.ps1
Set-Location "$($currentDirectory)"

# install python packages
Set-Location $currentDirectory
pip install --no-cache -r "$($currentDirectory)/requirements.txt"

# create a python kernel
python -m ipykernel install --user --name=mqit_kernel 

Write-Host "`n Complete.  Run python $pythonVersion from the path $pythonPath."
Write-Host "`n Use python virtual environment mqit-env."




Set-Location $currentDirectory


# Now Install Git in current directory 

# append git path to git.inf 
Add-Content -Path "git.inf" -Value "Dir=$($git_path)"

# get and install Git
Write-Host "`n Downloading GIT installer ..." -ForegroundColor Yellow
curl -o "./GitInstall.exe" "https://github.com/git-for-windows/git/releases/download/v2.46.0.windows.1/Git-2.46.0-64-bit.exe"

Write-Host "`n Installing GIT at ${gitPath}.." -ForegroundColor Yellow
./GitInstall.exe /SP- /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /LOADINF="git.inf"

Write-Host "`n Updating Path..." -ForegroundColor Yellow

# Add git CLI utilities to path
$PATH = [Environment]::GetEnvironmentVariable("PATH")
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$gitBinPath")


# Now install VS-code
Write-Host "`n Installing portable instance of VS Code"

# Get VS Code archive (zip file), expand it.
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
& $activateEnvCmd
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


Write-Host "`n VS-Code installed at $codeExePath.  You can start it with  with $codeExe." -ForegroundColor Yellow


Write-Host "`n Starting  VS-Code & opening folder for tests." -ForegroundColor Yellow
Set-Location $currentDirectory
