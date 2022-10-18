Write-Host -Object "Ensuring PowerShellGet 3+ is installed..."
# Ensuring PowerShellGet stable is latest version
Install-Module -Name PowerShellGet -Force -AllowClobber
# Installing PowerShellGet 3 Prerelease
Install-Module -Name PowerShellGet -Force -AllowPrerelease

if ($env:REQUIREDRESOURCEFILE) {
    $env:REQUIREDRESOURCE = Get-Content $env:REQUIREDRESOURCEFILE -Raw
}

Install-PSResource -RequiredResource $env:REQUIREDRESOURCE -AcceptLicense -TrustRepository -Scope Allusers