# Install Git in current directory 


$currentDirectory = Get-Location
$mqitPath = "$currentDirectory\mqit"
$git_path = "$mqitPath\Git"
$gitBinPath = "$gitPath\bin"


# Add git CLI utilities to path
$PATH = [Environment]::GetEnvironmentVariable("PATH")
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$gitBinPath")

# append git path to git.inf 
Add-Content -Path "git.inf" -Value "Dir=$($git_path)"


# get and install Git
Write-Host "`n Downloading GIT installer ..." -ForegroundColor Yellow
curl -o "./GitInstall.exe" "https://github.com/git-for-windows/git/releases/download/v2.46.0.windows.1/Git-2.46.0-64-bit.exe"

Write-Host "`n Installing GIT..." -ForegroundColor Yellow
./GitInstall.exe /SP- /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /LOADINF="git.inf"
