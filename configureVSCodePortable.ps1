
# install VS Code. Should be possible to user powershell, i.e. "Install-Script Install-VSCode; Install-VSCode.ps1 -AdditionalExtensions 'ms-azuretools.vscode-azurefunctions', 'ms-python.python'", but it requires admin privileges.

$minVersion = [Version]"1.8.0"
$vscodeurl =  "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive"


#$mqitPath = "$($env:USERPROFILE)\mqit"
$currentDirectory = Get-Location
$mqitPath = "$currentDirectory\mqit"

$venvPath = "$mqitPath\mqit-env\"
$activateEnvCmd = "$venvPath\Scripts\Activate.ps1"
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
cd $mqitpath
Expand-Archive -Path $downloadPath

#Make Data folder to store configuration
New-Item -ItemType Directory $dataPath

# Add to path
#$PATH = [Environment]::GetEnvironmentVariable("PATH")
#$code_path = "$($env:LOCALAPPDATA)\Programs\Microsoft VS Code"
#[Environment]::SetEnvironmentVariable("PATH", "$PATH;$code_path")

Remove-item $downloadPath

# install IQ# (note that it happens automatically when using Conda, not pip or via Code extensions)
#first switch to mqit-env virtual environment
& $activateEnvCmd
dotnet tool install -g Microsoft.Quantum.IQSharp
dotnet iqsharp install --user

Set-Location $currentDirectory

# Install any extensions
foreach ($extension in $extensions) {
    Write-Host "`nInstalling extension $extension..." -ForegroundColor Yellow
    & $codeExe --install-extension $extension
}

Write-Host "`n Code installed at $codeExePath.  Start code with $codeExe."

Set-Location $currentDirectory
