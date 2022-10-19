Write-Host -Object "Ensuring PowerShellGet 3+ is installed..."
# Ensuring PowerShellGet stable is latest version
Install-Module -Name PowerShellGet -Force -AllowClobber
# Installing PowerShellGet 3 Prerelease
Install-Module -Name PowerShellGet -Force -AllowPrerelease

if ($env:REQUIREDRESOURCEBASE64) {
    $ResourceJson = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($env:REQUIREDRESOURCE))
}
if ($env:REQUIREDRESOURCEFILE) {
    $ResourceJson = Get-Content $env:REQUIREDRESOURCEFILE -Raw
}

Install-PSResource -RequiredResource $ResourceJson -AcceptLicense -TrustRepository -Scope Allusers