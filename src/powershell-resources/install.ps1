Write-Host -Object "Ensuring PowerShellGet 2.2.5 is installed..."
# Ensuring PowerShellGet stable is at least version 2.2.5
$PowerShellGetMetadata = Get-Module -Name PowerShellGet
if ($PowerShellGetMetadata.Version -ge "2.2.5") {
    Write-Host -Object "Updating PowerShellGet to 2.2.5..."
    Install-Module -Name PowerShellGet -Force -AllowClobber -Scope AllUsers
} else {
    Write-Host -Object "PowerShellGet is up-to-date."
}

# Ensuring Microsoft.PowerShell.PSResourceGet is installed
$PSResourceGetMetadata = Get-Module -ListAvailable -Name Microsoft.PowerShell.PSResourceGet
if (!$PSResourceGetMetadata) {
    Write-Host -Object "'Microsoft.PowerShell.PSResourceGet' is not installed, now installing..."
    Install-Module -Name Microsoft.PowerShell.PSResourceGet -RequiredVersion 0.5.23-beta23 -Force -AllowPrerelease -Scope AllUsers
} elseif ($PSResourceGetMetadata.Version -gt "0.5.23") {
    Write-Warning -Message "'Microsoft.PowerShell.PSResourceGet' is higher than the pinned version of '0.5.23'. This may cause unexpected results. Consider opening a GitHub issue at 'https://github.com/natescherer/devcontainers-custom-features/issues' regarding this."
} elseif ($PSResourceGetMetadata.Version -lt "0.5.23") {
    Write-Host "'Microsoft.PowerShell.PSResourceGet' is less than the pinned version of '0.5.23'. Now updating..."
    Install-Module -Name Microsoft.PowerShell.PSResourceGet -RequiredVersion 0.5.23-beta23 -Force -AllowPrerelease -Scope AllUsers
} else {
    throw "Something went wrong while ensureing 'Microsoft.PowerShell.PSResourceGet' is installed. Consider opening a GitHub issue at 'https://github.com/natescherer/devcontainers-custom-features/issues' regarding this."
}

Write-Host -Object "Installing Resource(s)..."
if ($env:RESOURCES) {
    $Resource = $env:RESOURCES.split(",")
    Install-PSResource -Name $Resource -AcceptLicense -TrustRepository -Scope AllUsers -Verbose
}

if ($env:REQUIREDRESOURCEJSONBASE64) {
    $ResourceJson = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($env:REQUIREDRESOURCEJSONBASE64))
    Install-PSResource -RequiredResource $ResourceJson -AcceptLicense -TrustRepository -Scope AllUsers -Verbose
}

if ($env:REQUIREDRESOURCEJSONFILE) {
    Install-PSResource -RequiredResourceFile $env:REQUIREDRESOURCEJSONFILE -AcceptLicense -TrustRepository -Scope AllUsers -Verbose
}
