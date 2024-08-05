
# install VS Code. Should be possible to user powershell, i.e. "Install-Script Install-VSCode; Install-VSCode.ps1 -AdditionalExtensions 'ms-azuretools.vscode-azurefunctions', 'ms-python.python'", but it requires admin privileges.

$minVersion = [version]"1.1.0"
$vscodeurl =  "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
$destination = "$env:TEMP\vscode_installer.exe"
$extensions =
    "ms-python.python",
    "quantum.qsharp-lang-vscode",
    "ms-toolsai.jupyter"


#check if acceptable version already installed:
$v = get-package "Microsoft Visual Studio Code"
$version = [Version]$v.Attributes.Values[1]
if $version -gt $minVersion 
{

    curl -o $destination $vscodeurl
    .\VSCodeUserSetup.exe /VERYSILENT /NORESTART  /CURRENTUSER /MERGETASKS=!runcode

    # By default, VS Code is installed under C:\Users\{Username}\AppData\Local\Programs\Microsoft VS Code.

    # Setup will add VS Code to  %PATH%, but this requires a restart of powershell. Let's do it explicitly
    $PATH = [Environment]::GetEnvironmentVariable("PATH")
    $code_path = "$($env:LOCALAPPDATA)\Programs\Microsoft VS Code"
    [Environment]::SetEnvironmentVariable("PATH", "$PATH;$code_path")

    Remove-item $destination
}


#install VS Code extensions

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
