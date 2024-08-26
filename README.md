# Scripts for configuring MQIT software environment on Windows 10

This repository contains scripts that can be used to configure a development environment on Windows 10 for workshop activities on in MQIT subjects. 

The development environment is based on Azure Quantum Development kit with Python and Jupyter.  Visual Studio Code will be used to write, debug and execute code in Q# and Python. 

For our purposes it is convenient to use a 'portable' instance of VS Code that is independent of most of the software pre-installed on the LTU laboratory computers. The required VS-Code extensions will be installed, a python virtual environment created together with Python and Q# kernels created for use with Jupyter notebooks.  

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

Run 

```
.\configureAll.ps1
```

This will install portable versions of Python and VS-Code at the relative path ./mqit.  When complete, you can move the mqit folder to another location (e.g.your oneDrive folder) and launch VS-Code from their.  Note that you will need to update PATH environment variable for code.exe and python to be conventiently used.

The python virtual environment will be automatically activated by the script.  In a new session (or new powershell instance) you will need to activate the python environment by running the following command from the location where you installed or relocated the mqit folder.


``
.\mqit\mqit-env\activate
``

Alternatively, install the major pieces one at a time:

```
.\installGit.ps1
.\configurePythonPortable.ps1
.\configureVSCodePortable.ps1
```

The final part of the script configureVSCodePortable.ps1 attempts to install VS Code Extensions, which may fail.  If so, start VS Code and manually install the following extensions.
1. Python (ms-python.python)
2. Jupyter (ms-toolsai.jupyter)
3. Azure Quantum Development Kit (quantum.qsharp-lang-vscode)

The portable instance of VS Code is installed at .\mqit\VSCode\Code.exe

5.  Test:
    Select the mqit kernel: Open the Kernel Picker button on the top right-hand side of the notebook (or run the Notebook: Select Notebook Kernel command from the Command Palette).

6. Test: Open testQ.ipynb and execute

Note: The "Quantum Playground" is unusuable on the VDI due to firewall restrictions.

## Next Steps

See:
1. [Load a Q# sample program](https://learn.microsoft.com/en-us/azure/quantum/how-to-submit-jobs?tabs=tabid-python&pivots=ide-qsharp#load-a-q-sample-program).
2. [Run a Q# program](https://learn.microsoft.com/en-us/azure/quantum/how-to-submit-jobs?tabs=tabid-python&pivots=ide-qsharp#run-a-q-program)
3. [Visualise the frequency histogram](https://learn.microsoft.com/en-us/azure/quantum/how-to-submit-jobs?tabs=tabid-python&pivots=ide-qsharp#visualize-the-frequency-histogram)
4. [Visualise the Quantum Circuit](https://learn.microsoft.com/en-us/azure/quantum/how-to-submit-jobs?tabs=tabid-python&pivots=ide-qsharp#visualize-the-quantum-circuit)
4. [Connect to Azure Quantum and submit your job](https://learn.microsoft.com/en-us/azure/quantum/how-to-submit-jobs?tabs=tabid-python&pivots=ide-qsharp#connect-to-azure-quantum-and-submit-your-job)

## Requirements

1. Powershell
2. Dotnet

## Todo.

1. Need a more robust way of installing VS Code extensions
2. Replace windows-specific scripts with platform independent scripts. 
3. Add docker based solution (coming soon)
4. Need a portable installation of Git