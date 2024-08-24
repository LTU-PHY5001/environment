# G. van Riessen, LTU 2024

./configurePython.ps1

./configureVSCode.ps1

#  We need to manually install IQ# (note that it happens automatically when using Conda)
dotnet tool install -g Microsoft.Quantum.IQSharp
# there seems to be a bug that does not update PATH correctly.  Do it manually:
$PATH = [Environment]::GetEnvironmentVariable("PATH")
$tools_path = "$($env:USERPROFILE)\.dotnet\tools"
[Environment]::SetEnvironmentVariable("PATH", "$PATH;$tools_path")

dotnet iqsharp install --user

./installGit.ps1

# get extensions as vsix files
#mkdir extensions
#curl -o https://ms-python.gallery.vsassets.io/_apis/public/gallery/publisher/ms-python/extension/ms-python.python/2024.13.2024080201/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage
#https://${publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${publisher}/extension/${extension name}/${version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage

c#d extensions
## install all extensions from vsix files
Get-ChildItem . -Filter *.vsix | ForEach-Object { code --install-extension $_.FullName }