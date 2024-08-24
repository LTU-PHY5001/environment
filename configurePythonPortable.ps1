## Powershell script for installing a portable instance of PYTHON on windows (10+).
## Using embedded linux. 
## Tested for python 3.12.0 on Windows 10
##
## G van Riessen, 2024


$mqitPath = "$($env:USERPROFILE)\mqit"

Write-Host "`n This script will install portable instance of PYTHON to $mqitPath"


# create directory if not exists
if (!(test-path $mqitPath))
{
    New-Item -ItemType Directory $mqitPath
}

# install embedded python:

# grab the version string from the error message
$p.Exception.Message
$pythonVersion = "3.12.0" 
$pythonDownloadUrl = "https://www.python.org/ftp/python/$pythonVersion/python-$($pythonVersion)a5-embed-amd64.zip"

$installDir = "$mqitPath\python"
$downloadPath = $env:TEMP\python-embed.zip

# Download Python installer 
Write-Host "`n Downloading python installer to $downloadPath"

Invoke-WebRequest -Uri $pythonDownloadUrl -OutFile $
Expand-Archive -Path $downloadPath

# Install Python pseudo-silently, but let user know what is happening
Write-Host "`n Installing python $pythonVersion at $mqitPath ..."
Start-Process -FilePath "$env:TEMP\python-installer.exe" -ArgumentList "/quiet", "InstallAllUsers=0", "PrependPath=1", "DefaultCustomInstall=1", "DefaultPath=$installDir"  -Wait 

# Clean up 
Remove-Item "$env:TEMP\python-installer.exe" -Force

# Set path
$PATH = [Environment]::GetEnvironmentVariable("PATH")
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$installDir")

# install pip
curl -sSLO https://bootstrap.pypa.io/get-pip.py
python get-pip.py


# create virtual environment (python)
pip install --no-cache virtualenv
python -m venv "$($env:USERPROFILE)\mqit\mqit-env"

# Activate new virtual environment (save wd, activate change back to saved wd)
$currentDirectory = Get-Location
Set-Location "$($env:USERPROFILE)\mqit\mqit-env\Scripts\"
./Activate.ps1
Set-Location "$($currentDirectory)"

# install python packages
pip install --no-cache -r requirements.txt 

# create a python kernel
python -m ipykernel install --user --name=mqit_kernel 
