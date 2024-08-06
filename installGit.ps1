
# Install Git
curl -o GitInstall.exe https://github.com/git-for-windows/git/releases/download/v2.46.0.windows.1/Git-2.46.0-64-bit.exe
.\GitInstall.exe /SP- /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /LOADINF="git.inf"

# Add git CLI utilities to path
$PATH = [Environment]::GetEnvironmentVariable("PATH")
$git_path = "$($env:LOCALAPPDATA)\Programs\Git\bin"
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$git_path")

Remove-item GitInstall.exe 

