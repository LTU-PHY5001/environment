# Scripts for configuring MQIT software environment on Windows 10

This repository contains scripts that can be used to configure a development environment on Windows 10 for workshop activities on in MQIT subjects. 

For our purposes it is convenient to use a 'portable' instance of VS Code that is independent of most of the software pre-installed on the LTU laboratory computers. The required VS-Code extensions will be installed, a python virtual environment created together with a kernel created for use with Jupyter notebooks.  

 This same approach  should work on the on the LTU Virtual Desktop [VDI](https://www.latrobe.edu.au/students/support/it/teaching/myapps) or your own Windows 10/11 device.  Administrator privileges are not required and the configuration should not affect existing installations of VS Code, python, etc.  


**Follow these steps:**

1. Open Powershell
2. Get [MQIT-Portable](https://github.com/LTU-PHY5001/environment/archive/refs/tags/MQIT-Portable.zip):

```
curl -o MQIT-Portable.zip https://github.com/LTU-PHY5001/environment/archive/refs/tags/MQIT-Portable.zip
```

3. Unzip MQIT-Portable.zip and change directory

```
Expand-Archive -Path .\MQIT-Portable.zip
cd MQIT-Portable\environment-MQIT-Portable\
```

4. Run installation scripts:

```
.\installGit.ps1
.\configurePython.ps1
.\configureVSCodePortable.ps1
```

The final part of the script configureVSCodePortable.ps1 attempts to install VS Code Extensions, which may fail.  If so, start VS Code and manually install the following extensions.
1. Python (ms-python.python)
2. Jupyter (ms-toolsai.jupyter)
3. Azure Quantum Development Kit (quantum.qsharp-lang-vscode)

The portable instance of VS Code is installed at $($env:USERPROFILE)\mqit\VSCode\Code.exe

5.  Test:
    Select the mqit kernel: Open the Kernel Picker button on the top right-hand side of the notebook (or run the Notebook: Select Notebook Kernel command from the Command Palette).

6. Test: Open testQ.ipynb and execute

Note: The "Quantum Playground" is unusuable on the VDI due to firewall restrictions.


## Notes

Scripts are tested on Windows 10 and use web-scraping, which is inherently brittle.


## Todo.

1. Need a more robust way of installing VS Code extensions
2. Replace windows-specific scripts with platform independent scripts. 
3. Add docker based solution (coming soon)