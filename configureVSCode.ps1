
# install VS Code. Should be possible to user powershell, i.e. "Install-Script Install-VSCode; Install-VSCode.ps1 -AdditionalExtensions 'ms-azuretools.vscode-azurefunctions', 'ms-python.python'", but it requires admin privileges.

$minVersion = [Version]"1.8.0"
$vscodeurl =  "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
$destination = "$env:TEMP\vscode_installer.exe"
$codeExePath = "$($env:LOCALAPPDATA)\Programs\Microsoft VS Code\bin\code.exe"
$extensions =
    "ms-python.python",
    "quantum.qsharp-lang-vscode",
    "ms-toolsai.jupyter"

Write-Host "`nWill check version of VS Code that is installed "




#check if acceptable version already installed:
$v = get-package "Microsoft Visual Studio Code"
$version = [Version]$v.Attributes.Values[1]
if ($version -gt $minVersion) {
    
    Write-Host "`nInstalled version of Code is  $version.  Required > $minVersion. Doing nothing."

}
else
{
    Write-Host "`nVersion of VS Code is too old.  Need version > $minVersion.  Have $version..." -ForegroundColor Red
    Write-Host "`nInstalling current version...."
 
    
    & curl -o $destination $vscodeurl
    & $destination /VERYSILENT /NORESTART  /CURRENTUSER /MERGETASKS=!runcode

    # By default, VS Code is installed under C:\Users\{Username}\AppData\Local\Programs\Microsoft VS Code.

    # Setup will add VS Code to  %PATH%, but this requires a restart of powershell. Let's do it explicitly
    $PATH = [Environment]::GetEnvironmentVariable("PATH")
    $code_path = "$($env:LOCALAPPDATA)\Programs\Microsoft VS Code"
    [Environment]::SetEnvironmentVariable("PATH", "$PATH;$code_path")

    Remove-item $destination


    # Install any extensions
    if ($PSCmdlet.ShouldProcess(($extensions -join ','), "$codeExePath --install-extension")) {
        if ($IsLinux -or $IsMacOS) {
            # On *nix we need to install extensions as the user -- VSCode refuses root
            $extsSlashes = $extensions -join '/'
            sudo -H -u $env:SUDO_USER pwsh -c "`$exts = '$extsSlashes' -split '/'; foreach (`$e in `$exts) { $codeExePath --install-extension `$e }"
        }
        else {
            foreach ($extension in $extensions) {
                Write-Host "`nInstalling extension $extension..." -ForegroundColor Yellow
                & $codeExePath --install-extension $extension
            }
        }
    }

}

