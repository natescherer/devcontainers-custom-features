Write-Host -Object "Ensuring PowerShellGet 3+ is installed..."
# Ensuring PowerShellGet stable is latest version
Install-Module -Name PowerShellGet -Force -AllowClobber -Scope AllUsers
# Installing PowerShellGet 3 Prerelease
Install-Module -Name PowerShellGet -RequiredVersion 3.0.17-beta17 -Force -AllowPrerelease -Scope AllUsers

if ($env:RESOURCES) {
    $Resource = $env:RESOURCES.split(",")
}
if ($env:REQUIREDRESOURCEJSONBASE64) {
    $ResourceJson = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($env:REQUIREDRESOURCEJSONBASE64))
}
if ($env:REQUIREDRESOURCEJSONFILE) {
    $ResourceJson = Get-Content $env:REQUIREDRESOURCEJSONFILE -Raw
}

Write-Host -Object "Installing Resource(s)..."
if ($Resource) {
    Install-PSResource -Name $Resource -AcceptLicense -TrustRepository -Scope AllUsers -Verbose
}
if ($ResourceJson) {
    Install-PSResource -RequiredResource $ResourceJson -AcceptLicense -TrustRepository -Scope AllUsers -Verbose
}