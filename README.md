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

4. Run installation script:

Run 

```
.\configureAll.ps1
```

This will install portable versions of Python and VS-Code at the relative path ./mqit.  When complete, you can move the mqit folder to another location (e.g.your oneDrive folder) and launch VS-Code from their.  Note that you will need to update PATH environment variable for code.exe and python to be conventiently used.

The python virtual environment will be automatically activated by the script.  In a new session (or new powershell instance) you will need to activate the python environment by running the following command from the location where you installed or relocated the mqit folder.


``
.\mqit\mqit-env\activate
``

4. Install Extensions

The portable instance of VS Code is installed at .\mqit\VSCode\Code.exe

Start VS Code and install the following extensions:
1. Python ([ms-python.python](https://marketplace.visualstudio.com/items?itemName=ms-python.python))
2. Jupyter ([ms-toolsai.jupyter](https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter))
3. Azure Quantum Development Kit ([quantum.qsharp-lang-vscode](https://marketplace.visualstudio.com/items?itemName=quantum.qsharp-lang-vscode))

See [Using Extensions in VS Code](https://code.visualstudio.com/docs/introvideos/extend) for instructions for finding and installing extensions.


6.  Test:
   
    Open `test/testQ.ipynb` and follow instructions in the notebook for testing that you can use Q# and Python.  Note that the first step in these tests is the same first step you will follow to use Q# in any other Jupyter notebook, which is to select the mqit kernel.  This is done by opening the Kernel Picker via the "Select Kernel" button on the top right-hand side of the notebook (or run the Notebook: Select Notebook Kernel command from the Command Palette).


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

