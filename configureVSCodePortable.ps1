
# install VS Code. Should be possible to user powershell, i.e. "Install-Script Install-VSCode; Install-VSCode.ps1 -AdditionalExtensions 'ms-azuretools.vscode-azurefunctions', 'ms-python.python'", but it requires admin privileges.

$minVersion = [Version]"1.8.0"
$vscodeurl =  "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive"
$mqitPath = "$($env:USERPROFILE)\mqit"
$downloadPath =  "$mqitpath\VSCode.zip" 
$dataPath = "$mqitpath\VSCode\Data"
$codeExePath = "$mqitpath\VSCode\"
$codeExe = "$codeExePath\Code.exe"
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
& curl -o $downloadPath $vscodeurl
cd $downloadPath
Expand-Archive -Path $downloadPath


#Make Data folder to store configuration
New-Item -ItemType Directory $dataPath

# Add to path
#$PATH = [Environment]::GetEnvironmentVariable("PATH")
#$code_path = "$($env:LOCALAPPDATA)\Programs\Microsoft VS Code"
#[Environment]::SetEnvironmentVariable("PATH", "$PATH;$code_path")

Remove-item $downloadPath

# Install any extensions
foreach ($extension in $extensions) {
    Write-Host "`nInstalling extension $extension..." -ForegroundColor Yellow
    & $codeExe --install-extension $extension
}


Write-Host "`n Code installed at $codeExePath.  Start code with $codeExe."
