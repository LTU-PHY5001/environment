## Powershell script for installing a portable instance of PYTHON on windows (10+).
## Using embedded linux. 
## Tested for python 3.12.0 on Windows 10
##
## G van Riessen, 2024


#$mqitPath = "$($env:USERPROFILE)\mqit"
$mqitPath = ".\mqit"

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
$pipDownloadURL = "https://bootstrap.pypa.io/get-pip.py"
$downloadPipPath = "./get-pip.py"
#$installDir = "$mqitPath\python"
$downloadPath =  "$mqitPath\python-$($pythonVersion)a5-embed-amd64.zip"
$pythonPath =    "$mqitPath\python-$($pythonVersion)a5-embed-amd64"


# Download Python installer 
Write-Host "`n Downloading python installer to $downloadPath"

Invoke-WebRequest -Uri $pythonDownloadUrl -OutFile $downloadPath


# Install Python pseudo-silently, but let user know what is happening
Write-Host "`n Installing python $pythonVersion at $mqitPath ..."
$currentDirectory = Get-Location
Set-Location $mqitPath
Expand-Archive -Path $downloadPath

# Clean up 
Remove-Item $downloadPath -Force

# Set path
$PATH = [Environment]::GetEnvironmentVariable("PATH")
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$pythonPath")

# install pip
Set-Location $mqitPath
Invoke-WebRequest -Uri $pipDownloadURL -OutFile $downloadPipPath
python get-pip.py


# create virtual environment (python)
pip install --no-cache virtualenv
$pythonPath/python -m venv "$mqitPath\mqit-env"

# Activate new virtual environment (save wd, activate change back to saved wd)
$currentDirectory = Get-Location
Set-Location "$mqitPath\mqit-env\Scripts\"
./Activate.ps1
Set-Location "$($currentDirectory)"

# install python packages
pip install --no-cache -r requirements.txt 

# create a python kernel
python -m ipykernel install --user --name=mqit_kernel 


Write-Host "`n Complete.  Run python $pythonVersion from the path $pythonPath."
Write-Host "`n Use python virtual environment mqit-env."

