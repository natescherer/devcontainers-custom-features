$PsrgMinVer = "1.0.1"

if ($PSVersionTable.PSVersion -ge 7.4) {
    # This test will need updated if a version above 1.0.1 (bundled/invisible in pwsh 7.4) is ever needed
    Write-Host -Object "PowerShell is 7.4 or above, no need to install Microsoft.PowerShell.PSResourceGet."
} else {
    Write-Host -Object "Ensuring PowerShellGet 2.2.5 is installed..."
    # Ensuring PowerShellGet stable is at least version 2.2.5
    $PowerShellGetMetadata = Get-Module -Name PowerShellGet
    if ($PowerShellGetMetadata.Version -lt "2.2.5") {
        Write-Host -Object "Updating PowerShellGet to 2.2.5..."
        Install-Module -Name PowerShellGet -Force -AllowClobber -Scope AllUsers
    } else {
        Write-Host -Object "PowerShellGet is up-to-date."
    }

    Write-Host -Object "Ensuring Microsoft.PowerShell.PSResourceGet is installed..."
    # Ensuring Microsoft.PowerShell.PSResourceGet is installed
    $PSResourceGetMetadata = Get-Module -ListAvailable -Name Microsoft.PowerShell.PSResourceGet
    if (!$PSResourceGetMetadata) {
        Write-Host -Object "'Microsoft.PowerShell.PSResourceGet' is not installed, now installing..."
        Install-Module -Name Microsoft.PowerShell.PSResourceGet -Scope AllUsers
    } elseif ($PSResourceGetMetadata.Version -lt $PsrgMinVer) {
        Write-Host "'Microsoft.PowerShell.PSResourceGet' is less than the pinned version of '$PsrgMinVer'. Now updating..."
        Install-Module -Name Microsoft.PowerShell.PSResourceGet -Scope AllUsers
    } elseif ($PSResourceGetMetadata.Version -eq $PsrgMinVer) {
        Write-Host "'Microsoft.PowerShell.PSResourceGet' is already at pinned version of '$PsrgMinVer'."
    } else {
        throw "Something went wrong while ensuring 'Microsoft.PowerShell.PSResourceGet' is installed. Consider opening a GitHub issue at 'https://github.com/natescherer/devcontainers-custom-features/issues' regarding this."
    }
}

# This is a workaround for https://github.com/PowerShell/PSResourceGet/issues/1540
if ($IsLinux) {
    Write-Host -Object "Ensuring Script target directories exist..."
    New-Item -Path "/usr/local/share/powershell/Scripts/InstalledScriptInfos" -ItemType Directory -Force
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
