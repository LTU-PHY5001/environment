$extensions = @("ms-python.python",
              "quantum.qsharp-lang-vscode",
              "ms-toolsai.jupyter")

$codeSysPath = "c:\Program Files\Microsoft VS Code\Code.exe"
$codeUsrPath = "$($env:LOCALAPPDATA)\Programs\Microsoft VS Code\bin\code.exe"

# Use code installed in user space, if it exists.  Otherwise, use code where it is expected due to system-wide installation
if ([System.IO.File]::Exists($codeUsrPath)){
    $codeExePath = $codeUsrPath
}
else {
     $codeExePath = $codeSysPath
}

echo $codeExePath


foreach ($extension in $extensions) {
    Write-Host "`nInstalling extension $extension..." -ForegroundColor Yellow
    & $codeExePath --install-extension $extension
}