
# Install Git

Write-Host "`n Installing GIT..." -ForegroundColor Yellow


try {
    curl -o "./GitInstall.exe" "https://github.com/git-for-windows/git/releases/download/v2.46.0.windows.1/Git-2.46.0-64-bit.exe
    ./GitInstall.exe /SP- /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /LOADINF="git.inf"
    }
catch {
    Write-Host  "download failed"
    }


# Add git CLI utilities to path
$PATH = [Environment]::GetEnvironmentVariable("PATH")
$git_path = "$($env:LOCALAPPDATA)\Programs\Git\bin"
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$git_path")

try {
    Remove-item "./GitInstall.exe"
    }
catch {
    Write-Host "Removing $installer failed"
    }

