[CmdletBinding()]
param([string]$Folder = "$PSScriptRoot\test")
$ErrorActionPreference = 'Stop'
$mqitPath = Join-Path $PSScriptRoot 'mqit'
$codeExe = Join-Path $mqitPath 'VSCode\Code.exe'
$pythonExe = Join-Path $mqitPath 'mqit-env\Scripts\python.exe'
$gitExe = Join-Path $mqitPath 'Git\cmd\git.exe'
foreach ($required in @($codeExe, $pythonExe, $gitExe)) {
    if (-not (Test-Path -LiteralPath $required)) { throw "Missing $required. Complete install.ps1 first." }
}
$env:Path = "$mqitPath\Git\cmd;$mqitPath\mqit-env\Scripts;$env:Path"
$env:VIRTUAL_ENV = Join-Path $mqitPath 'mqit-env'
$resolvedFolder = (Resolve-Path -LiteralPath $Folder).Path
& $codeExe --new-window $resolvedFolder
