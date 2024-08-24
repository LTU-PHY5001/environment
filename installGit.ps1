
# Install Git

Write-Host "`n Installing GIT..." -ForegroundColor Yellow

$installer = "./GitInstall.exe"

try {
    curl -o $installer https://github.com/git-for-windows/git/releases/download/v2.46.0.windows.1/Git-2.46.0-64-bit.exe
    $installer /SP- /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /LOADINF="git.inf"
    }
catch {
    Write-Host  "download failed"
    }


# Add git CLI utilities to path
$PATH = [Environment]::GetEnvironmentVariable("PATH")
$git_path = "$($env:LOCALAPPDATA)\Programs\Git\bin"
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$git_path")

try {
    Remove-item $installer
    }
catch {
    Write-Host "Removing $installer failed"
    }

