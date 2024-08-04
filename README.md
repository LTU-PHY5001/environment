# Scripts for configuring MQIT software environment

This repository contains scripts that can be used to configure a development environmenton Windows 10 for workshop activities on in MQIT subjects. 

The scripts are primarily intended for use on the generic LTU Virtual Desktop [VDI](https://www.latrobe.edu.au/students/support/it/teaching/myapps). They should work on Windows 10 without administrator privileges.


## Instructions

1. Download [https://github.com/LTU-PHY5001/environment/archive/refs/tags/VDI.zip](https://github.com/LTU-PHY5001/environment/archive/refs/tags/VDI.zip) and unzip.
2. Run ConfigureEnvironment.ps1 in Powershell

This should setup the following:
1. Python environment ('mqit-env')
2. QDK 
3. VS Code
4. VS Code extensions for Python, Jupyter, and Q#
5. Git

Start VS Code:  Run the command "code".

Select the mqit kernerl



## Notes

Scripts are tested on Windows 10 and use web-scraping, which is inherently brittle.

Python 3.9 is installed on VDI, but the script will check for existance of Python and if no version is available, it will installed Python 3.9.

Dotnet is required to installed IQSharp.  The script currently assumes that Dotnet is installed (assumption OK for VDI).  Dotnet can be downloaded here from [https://dotnet.microsoft.com/en-us/download](https://dotnet.microsoft.com/en-us/download)

The "Quantum Playground" is unusuable on the VDI due to firewall restrictions.

## Todo./

1. Replace windows-specific scripts with platform independent scripts. 
2. Add docker based solution (coming soon)