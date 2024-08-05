
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
python -m venv "$($env:USERPROFILE)\mqit"

# Activate new virtual environment (save wd, activate change back to saved wd)
$currentDirectory = Get-Location
Set-Location "$($env:USERPROFILE)\mqit\Scripts\"
./Activate.ps1
Set-Location "$($currentDirectory)"

# install python packages
pip install --no-cache -r requirements.txt 

# create a python kernel
python -m ipykernel install --user --name=mqit_kernel 
