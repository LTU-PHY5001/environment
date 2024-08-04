
# G van Riessen, LTU 2024


#check if python is installed
# redirect stderr into stdout
$p = &{python -V} 2>&1
$version = if($p -is [System.Management.Automation.ErrorRecord])
{
    # grab the version string from the error message
    $p.Exception.Message
    $pythonVersion = "3.9" 
    $pythonDownloadUrl = "https://www.python.org/ftp/python/$pythonVersion/python-$pythonVersion-amd64.exe" 
    
    #$installDir = "C:\Python" 
    
    # Download Python installer 
    Invoke-WebRequest -Uri $pythonDownloadUrl -OutFile "$env:TEMP\python-installer.exe" 
    
    # Install Python silently 
    #Start-Process -FilePath "$env:TEMP\python-installer.exe" -ArgumentList "/quiet", "InstallAllUsers=0", "PrependPath=1", "DefaultCustomInstall=1", "DefaultPath=$installDir" -Wait 
    Start-Process -FilePath "$env:TEMP\python-installer.exe" -ArgumentList "/quiet", "InstallAllUsers=0", "PrependPath=1", "DefaultCustomInstall=1" -Wait 
    

    # Clean up 
    Remove-Item "$env:TEMP\python-installer.exe" -Force

}
else 
{
    # otherwise return as is
    $p
}


# create virtual environment (python)
pip install virtualenv
python -m venv mqit

# Activate new virtual environment
#.\mqit\Scripts\Activate.ps1 
powershell -File "$($env:USERPROFILE)\mqit\Scripts\Activate.ps1"
pip install --no-cache -r requirements.txt 

# create a python kernel
python -m ipykernel install --user --name=mqit_kernel 

# install VS Code. Should be possible to user powershell, i.e. "Install-Script Install-VSCode; Install-VSCode.ps1 -AdditionalExtensions 'ms-azuretools.vscode-azurefunctions', 'ms-python.python'", but it requires admin privileges.

# By default, VS Code is installed under C:\Users\{Username}\AppData\Local\Programs\Microsoft VS Code.
#curl -o VSCodeSetup.exe 'https://vscode.download.prss.microsoft.com/dbazure/download/stable/89de5a8d4d6205e5b11647eb6a74844ca23d2573/VSCodeUserSetup-x64-1.92.0.exe'
curel -o VSCodeUserSetup.exe "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
.\VSCodeUserSetup.exe /VERYSILENT /NORESTART /MERGETASKS=!runcode

# Setup will add VS Code to  %PATH%, but this requires a restart of powershell. Let's do it explicitly
$PATH = [Environment]::GetEnvironmentVariable("PATH")
$code_path = "$($env:LOCALAPPDATA)\Programs\Microsoft VS Code"
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$code_path")


#  We need to manually install IQ# (not it happens automatically when using Conda)
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

