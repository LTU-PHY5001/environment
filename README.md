# Scripts for configuring MQIT software environment on Windows 10

This repository contains scripts that can be used to configure a development environment on Windows 10 for workshop activities on in MQIT subjects. The instructions are specifically for LTU laboratory computers in the SCEMS School.

The development environment is based on Azure Quantum Development kit with Python and Jupyter.  Visual Studio Code will be used to write, debug and execute code in Q# and Python. 

For our purposes it is convenient to use a 'portable' instance of VS Code that is independent of most of the software pre-installed on the LTU laboratory computers. The required VS-Code extensions will be installed, a python virtual environment created together with Python and Q# kernels created for use with Jupyter notebooks.  

## <a name="instructions"></a> Instructions for Installation on PS1 Laboratory Computers

1. Open Powershell.

    You can press <kbd>windows</kbd>+<kbd>x</kbd> and choose ''Windows Powershell'' or press <kbd>i</kbd>.

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
    .\install.ps1
    ```

    This will install portable versions of Python, VS-Code and Git at the relative path .\MQIT-Portable\environment-MQIT-Portable\mqit.  This step may take about 5 minutes.

5. Open the installed version of VS-Code

    Start VS-Code from .\mqit\VSCode\code.exe using the following command:

    ```
    & ".\mqit\VSCode\code.exe" .\
    ```

6. Install VS-Code Extensions

    To install required extensions, open the 'Extensions' view in the VS Code sidebar, or press F1 and select "Extensions: Install Extensions" from the quick menu, and search for the following:

    - Python ([ms-python.python](https://marketplace.visualstudio.com/items?itemName=ms-python.python))
    - Jupyter ([ms-toolsai.jupyter](https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter))
    - Azure Quantum Development Kit ([quantum.qsharp-lang-vscode](https://marketplace.visualstudio.com/items?itemName=quantum.qsharp-lang-vscode))

    For more detailed instructions on installing extensions, see:  [Using Extensions in VS Code](https://code.visualstudio.com/docs/introvideos/extend).

6.  Test:
   
    Open the Jupyter notebook `test\testQ.ipynb' in VS-Code.  It should be listed in the file 'Explorer' in VS-Code. If not, open the folder where it can be found using 'FILE->Open Folder...' and choose the test folder path (.\MQIT-Portable\environment-MQIT-Portable)

    Follow the instructions in the Jupyter notebook 'testQ.ipynb' for testing that you can use Q# and Python. 
    
    If the code in the Jupyter notebook executes without an error you are ready to use the MQIT software environment for classes and assignments.


##  Optional Configuration step 

    You can move the portable versions of Python and VS-Code by copying the MQIT-Portable directory to  another location (e.g. your oneDrive folder or external disk).   You will be able to launch VS-Code from that location next time you use the  Note that you will need to update PATH environment variables for code.exe and python to be conveniently used.

##  Using the Python environment from a terminal

    You can activate the virtual python environment configured by the above scripts by running the following command from the location where you installed or relocated the mqit folder:

    ```
    .\mqit\mqit-env\activate
    ```

