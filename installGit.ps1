# Install Git in current directory 

Write-Host "`n Installing GIT..." -ForegroundColor Yellow

$currentDirectory = Get-Location
$mqitPath = "$currentDirectory\mqit"

# Add git CLI utilities to path
$PATH = [Environment]::GetEnvironmentVariable("PATH")
$git_path = "$($mqitPath)\Git"
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$git_path\bin")

try {
    curl -o "./GitInstall.exe" "https://github.com/git-for-windows/git/releases/download/v2.46.0.windows.1/Git-2.46.0-64-bit.exe"
    ./GitInstall.exe /SP- /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /LOADINF="git.inf"
    }
catch {
    Write-Host  "download failed"
    }


try {
    Remove-item "./GitInstall.exe"
    }
catch {
    Write-Host "Removing $installer failed"
    }

