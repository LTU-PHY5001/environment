# Scripts for configuring MQIT software environment on Windows 10

This repository contains scripts that can be used to configure a development environment on Windows 10 for workshop activities on in MQIT subjects. The instructions are specifically for LTU laboratory computers in the SCEMS School.

The development environment is based on Azure Quantum Development kit with Python and Jupyter.  Visual Studio Code will be used to write, debug and execute code in Q# and Python. 

For our purposes it is convenient to use a 'portable' instance of VS Code that is independent of most of the software pre-installed on the LTU laboratory computers. The required VS-Code extensions will be installed, a python virtual environment created together with Python and Q# kernels created for use with Jupyter notebooks.  

 This same approach  should work on the on the LTU Virtual Desktop [VDI](https://www.latrobe.edu.au/students/support/it/teaching/myapps) or your own Windows 10/11 device.  Administrator privileges are not required and the configuration should not affect existing installations of VS Code, python, etc.  


**Follow these steps:**

1. Open Powershell
2. Get [MQIT-Portable](https://github.com/LTU-PHY5001/environment/archive/refs/tags/MQIT-Portable.zip)

    In Powershell enter the following command (copy and paste it) to download and unzip a file containing everything you need:

    ```
    curl -o MQIT-Portable.zip https://github.com/LTU-PHY5001/environment/archive/refs/tags/MQIT-Portable.zip
    Expand-Archive -Path .\MQIT-Portable.zip
    
    ```


3. Run installation script:

    Run 

    ```
    cd MQIT-Portable\environment-MQIT-Portable\
    .\configureAll.ps1
    ```

    This will install portable versions of Python and VS-Code at the relative path .\MQIT-Portable\environment-MQIT-Portable\mqit.

5. Open the installed version of VS-Code

    Start VS-Code from .\MQIT-Portable\environment-MQIT-Portable\mqit\VSCode\code.exe using the following command:

    ```
    .\MQIT-Portable\environment-MQIT-Portable\mqit\VSCode\code.exe  .\MQIT-Portable\environment-MQIT-Portable\mqit\test\
    ```

6. Install VS-Code Extensions

   Install the following extensions:
    1. Python ([ms-python.python](https://marketplace.visualstudio.com/items?itemName=ms-python.python))
    2. Jupyter ([ms-toolsai.jupyter](https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter))
    3. Azure Quantum Development Kit ([quantum.qsharp-lang-vscode](https://marketplace.visualstudio.com/items?itemName=quantum.qsharp-lang-vscode))

    See [Using Extensions in VS Code](https://code.visualstudio.com/docs/introvideos/extend) for instructions for finding and installing extensions.


6.  Test:
   
    Open the Jupyter notebook `testQ.ipynb' in VS-Code.  It should be listed in the file 'Explorer' in VS-Code. If not, open it using 'FILE->Open Folder...' and choose the test folder path (.\MQIT-Portable\environment-MQIT-Portable\test)

    
    Follow the instructions in the Jupyter notebook 'testQ.ipynb' for testing that you can use Q# and Python.  Note that the first step in these tests is the same first step you will follow to use Q# in any other Jupyter notebook, which is to select the mqit kernel.  This is done by opening the Kernel Picker via the "Select Kernel" button on the top right-hand side of the notebook (or run the Notebook: Select Notebook Kernel command from the Command Palette).


7. Move installed components to another location [optional]

    You can move the portable versions of Python and VS-Code by copying  folder ./mqit to  another location (e.g.your oneDrive folder or external disk).   You will be able to launch VS-Code from that location next time you use the  Note that you will need to update PATH environment variables for code.exe and python to be conveniently used.

    The mqit python virtual environment will be activated during the above installation.  In a new session (or new powershell instance) you will need to activate the python environment by running the following command from the location where you installed or relocated the mqit folder.

``
.\mqit\mqit-env\activate
``

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

