
# G. van Riessen, LTU 2024


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
    Invoke-WebRequest -Uri $pythonDownloadUr