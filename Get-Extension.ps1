# example usage: Get-Extension -Publisher 'gep13' -ExtensionName 'chocolatey-azuredevops' -Version '0.2.0' -OutputLocation 'C:\Users\Azurekid'

# source: https://gist.github.com/azurekid/ca641c47981cf8074aeaf6218bb9eb58

[CmdletBinding()]
param
(
    [Parameter(Mandatory = $true)]
    [string] $Publisher,

    [Parameter(Mandatory = $true)]
    [string] $ExtensionName,

    [Parameter(Mandatory = $true)]
    [ValidateScript( {
            If ($_ -match "^([0-9]+\.[0-9]+\.[0-9]+)$") {
                $True
            }
            else {
                Throw "$_ is not a valid version number. Version can only contain digits"
            }
        })]
    [string] $Version,

    [Parameter(Mandatory = $true)]
    [string] $OutputLocation
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Output "Publisher:        $($Publisher)"
Write-Output "Extension name:   $($ExtensionName)"
Write-Output "Version:          $($Version)"
Write-Output "Output location   $($OutputLocation)"

$baseUrl = "https://$($Publisher).gallery.vsassets.io/_apis/public/gallery/publisher/$($Publisher)/extension/$($ExtensionName)/$($Version)/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
$outputFile = "$($Publisher)-$($ExtensionName)-$($Version).visx"

if (Test-Path $OutputLocation) {
    try {
        Write-Output "Retrieving extension..."
        [uri]::EscapeUriString($baseUrl) | Out-Null
        Invoke-WebRequest -Uri $baseUrl -OutFile "$OutputLocation\$outputFile"
    }
    catch {
        Write-Error "Unable to find the extension in the marketplace"
    }
}
else {
    Write-Output "The Path $($OutputLocation) does not exist"
}