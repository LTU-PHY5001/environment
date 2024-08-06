
# install VS Code. Should be possible to user powershell, i.e. "Install-Script Install-VSCode; Install-VSCode.ps1 -AdditionalExtensions 'ms-azuretools.vscode-azurefunctions', 'ms-python.python'", but it requires admin privileges.

$minVersion = [Version]"1.8.0"
$vscodeurl =  "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive"
$mqitPath = "$($env:USERPROFILE)\mqit"
$downloadPath =  "$($env:LOCALAPPDATA)\mqit\VSCode.zip" 
$dataPath = "$($env:USERPROFILE)\mqit\VSCode\Data"
$codeExePath = "$($env:USERPROFILE)\mqit\VSCode\Code.exe"
$extensions = @("ms-python.python",
              "quantum.qsharp-lang-vscode",
              "ms-toolsai.jupyter")


Write-Host "`n Installing portable instance of VS Code"
 
    
# create directory if not exists
if (!(test-path $mqitPath))
{
    New-Item -ItemType Directory $mqitPath
}

# Get VS Code archive (zip file), expand it.
& curl -o $destination $vscodeurl
& $destination /VERYSILENT /NORESTART  /CURRENTUSER /MERGETASKS=!runcode
Expand-Archive -Path $downloadPath
=New-Item -ItemType Directory $dataPath


# By default, VS Code is installed under C:\Users\{Username}\AppData\Local\Programs\Microsoft VS Code.

# Setup will add VS Code to  %PATH%, but this requires a restart of powershell. Let's do it explicitly
$PATH = [Environment]::GetEnvironmentVariable("PATH")
$code_path = "$($env:LOCALAPPDATA)\Programs\Microsoft VS Code"
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$code_path")

Remove-item $destination

# Install any extensions
foreach ($extension in $extensions) {
    Write-Host "`nInstalling extension $extension..." -ForegroundColor Yellow
    & $codeExePath --install-extension $extension
}
