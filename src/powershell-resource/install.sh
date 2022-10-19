#!/bin/sh
set -e

echo "Feature 'powershell-resource' starting..."

if command -v pwsh > /dev/null; then
    echo "Confirmed PowerShell is installed"
else
    echo "PowerShell is not installed. Please ensure it is installed before using this feature."
    exit 127
fi

if [! "$REQUIREDRESOURCEBASE64" -eq ""] && [! "$REQUIREDRESOURCEFILE" -eq ""]; then
    echo "You cannot specify both requiredResource and requiredResourceFile for this feature."
    exit 1
fi

if ["$REQUIREDRESOURCEBASE64" -eq ""] && ["$REQUIREDRESOURCEFILE" -eq ""]; then
    echo "Either requiredResource or requiredResourceFile must be specified for this feature."
    exit 1
fi

pwsh -f install.ps1