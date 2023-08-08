$PsrgPinnedVerShort = "0.5.23"
$PsrgPinnedVer = "0.5.23-beta23"

Write-Host -Object "Ensuring PowerShellGet 2.2.5 is installed..."
# Ensuring PowerShellGet stable is at least version 2.2.5
$PowerShellGetMetadata = Get-Module -Name PowerShellGet -ListAvailable
if (($PowerShellGetMetadata.Version -lt "2.2.5") -or !$PowerShellGetMetadata.Version) {
    Write-Host -Object "Updating PowerShellGet to 2.2.5..."
    Install-Module -Name PowerShellGet -Force -AllowClobber -Scope AllUsers
} else {
    Write-Host -Object "PowerShellGet is up-to-date."
}

# Ensuring NuGet package provider is installed
Write-Host -Object "Ensuring NuGet Package Provider >=2.8.5.201 is installed..."
$NuGetMetadata = Get-PackageProvider -Name NuGet
if (($NuGetMetadata.Version -lt 2.8.5.201) -or !$NuGetMetadata.Version) {
    Write-Host -Object "Updating NuGet Package Provider..."
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
} else {
    Write-Host -Object "NuGet Package Provider is up-to-date."
}

# Ensuring Microsoft.PowerShell.PSResourceGet is installed
$PSResourceGetMetadata = Get-Module -ListAvailable -Name Microsoft.PowerShell.PSResourceGet
if (!$PSResourceGetMetadata) {
    Write-Host -Object "'Microsoft.PowerShell.PSResourceGet' is not installed, now installing..."
    Install-Module -Name Microsoft.PowerShell.PSResourceGet -RequiredVersion $PsrgPinnedVer -Force -AllowPrerelease -Scope AllUsers
} elseif ($PSResourceGetMetadata.Version -gt $PsrgPinnedVerShort) {
    Write-Warning -Message "'Microsoft.PowerShell.PSResourceGet' is higher than the pinned version of '$PsrgPinnedVer'. This may cause unexpected results. Consider opening a GitHub issue at 'https://github.com/natescherer/devcontainers-custom-features/issues' regarding this."
} elseif ($PSResourceGetMetadata.Version -lt $PsrgPinnedVerShort) {
    Write-Host "'Microsoft.PowerShell.PSResourceGet' is less than the pinned version of '$PsrgPinnedVer'. Now updating..."
    Install-Module -Name Microsoft.PowerShell.PSResourceGet -RequiredVersion $PsrgPinnedVer -Force -AllowPrerelease -Scope AllUsers
} elseif ($PSResourceGetMetadata.Version -eq $PsrgPinnedVerShort) {
    Write-Host "'Microsoft.PowerShell.PSResourceGet' is already at pinned version of '$PsrgPinnedVer'."
} else {
    throw "Something went wrong while ensuring 'Microsoft.PowerShell.PSResourceGet' is installed. Consider opening a GitHub issue at 'https://github.com/natescherer/devcontainers-custom-features/issues' regarding this."
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
