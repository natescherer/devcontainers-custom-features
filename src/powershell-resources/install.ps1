Write-Host -Object "Ensuring PowerShellGet 3+ is installed..."
# Ensuring PowerShellGet stable is latest version
Install-Module -Name PowerShellGet -Force -AllowClobber -Scope AllUsers
# Installing PowerShellGet 3 Prerelease
Install-Module -Name PowerShellGet -RequiredVersion 3.0.17-beta17 -Force -AllowPrerelease -Scope AllUsers

if ($env:REQUIREDRESOURCEBASE64) {
    $ResourceJson = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($env:REQUIREDRESOURCEBASE64))
}
if ($env:REQUIREDRESOURCEFILE) {
    $ResourceJson = Get-Content $env:REQUIREDRESOURCEFILE -Raw
}

Write-Host -Object "Installing Resource(s)..."
Install-PSResource -RequiredResource $ResourceJson -AcceptLicense -TrustRepository -Scope AllUsers -Verbose