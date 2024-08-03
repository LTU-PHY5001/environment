
pip install virtualenv
python -m venv mqit
.\mqit\Scripts\Activate.ps1 
pip install --no-cache -r requirements.txt 

# create a python kernel
python -m ipykernel install --user --name=mqit_kernel 

# install VS Code
curl -o VSCode.exe  'https://code.visualstudio.com/sha/download?build=stable&os=cli-win32-x64'
.\VSCode.exe /VERYSILENT /MERGETASKS=!runcode

# Install Git
curl -o GitInstall.exe https://github.com/git-for-windows/git/releases/download/v2.46.0.windows.1/Git-2.46.0-64-bit.exe
.\GitInstall.exe /VER