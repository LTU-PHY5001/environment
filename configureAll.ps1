# G. van Riessen, LTU 2024

./configurePython


# install VS Code. Should be possible to user powershell, i.e. "Install-Script Install-VSCode; Install-VSCode.ps1 -AdditionalExtensions 'ms-azuretools.vscode-azurefunctions', 'ms-python.python'", but it requires admin privileges.

# By default, VS Code is installed under C:\Users\{Username}\AppData\Local\Programs\Microsoft VS Code.
#curl -o VSCodeSetup.exe 'https://vscode.download.prss.microsoft.com/dbazure/download/stable/89de5a8d4d6205e5b11647eb6a74844ca23d2573/VSCodeUserSetup-x64-1.92.0.exe'
curl -o VSCodeUserSetup.exe "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
.\VSCodeUserSetup.exe /VERYSILENT /NORESTART  /CURRENTUSER /MERGETASKS=!runcode

# Setup will add VS Code to  %PATH%, but this requires a restart of powershell. Let's do it explicitly
$PATH = [Environment]::GetEnvironmentVariable("PATH")
$code_path = "$($env:LOCALAPPDATA)\Programs\Microsoft VS Code"
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$code_path")


#  We need to manually install IQ# (note that it happens automatically when using Conda)
dotnet tool install -g Microsoft.Quantum.IQSharp
# there seems to be a bug that does not update PATH correctly.  Do it manually:
$PATH = [Environment]::GetEnvironmentVariable("PATH")
$tools_path = "$($env:USERPROFILE)\.dotnet\tools"
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$tools_path")

dotnet iqsharp install --user

# Install Git
curl -o GitInstall.exe https://github.com/git-for-windows/git/releases/download/v2.46.0.windows.1/Git-2.46.0-64-bit.exe
.\GitInstall.exe /SP- /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /LOADINF="git.inf"

# Add git CLI utilities to path
$PATH = [Environment]::GetEnvironmentVariable("PATH")
$git_path = "$($env:LOCALAPPDATA)\Programs\Git\bin"
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$git_path")

#install VS Code extensions
$extensions =
    "ms-python.python",
    "quantum.qsharp-lang-vscode",
    "ms-toolsai.jupyter"
    "ms-vscode.powershell"

$cmd = "code --list-extensions"
Invoke-Expression $cmd -OutVariable output | Out-Null
$installed = $output -split "\s"

foreach ($ext in $extensions) {
    if ($installed.Contains($ext)) {
        Write-Host $ext "already installed." -ForegroundColor Gray
    } else {
        Write-Host "Installing" $ext "..." -ForegroundColor White
        code --install-extension $ext
    }
}

# get extensions as vsix files
#mkdir extensions
#curl -o https://ms-python.gallery.vsassets.io/_apis/public/gallery/publisher/ms-python/extension/ms-python.python/2024.13.2024080201/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage
#https://${publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${publisher}/extension/${extension name}/${version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage

c#d extensions
## install all extensions from vsix files
Get-ChildItem . -Filter *.vsix | ForEach-Object { code --install-extension $_.FullName }