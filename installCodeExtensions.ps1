$extensions =
    "ms-python.python",
    "quantum.qsharp-lang-vscode",
    "ms-toolsai.jupyter", 
    "ms-vscode.powershell"


$codeExePath = "$($env:LOCALAPPDATA)\Programs\Microsoft VS Code\bin\code.exe"

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