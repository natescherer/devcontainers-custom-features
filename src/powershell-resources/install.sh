#!/bin/sh
set -e

echo "Feature 'powershell-resources' starting..."

if ! command -v pwsh > /dev/null; then
    echo "PowerShell is not installed. Please ensure it is installed before using this feature."
    exit 127
fi

if [ "$REQUIREDRESOURCEBASE64" != "" ] && [ "$REQUIREDRESOURCEFILE" != "" ]; then
    echo "You cannot specify both requiredResourceBase64 and requiredResourceFile for this feature."
    exit 1
fi

if [ -z "$REQUIREDRESOURCEBASE64" ] && [ -z "$REQUIREDRESOURCEFILE" ]; then
    echo "Either requiredResourceBase64 or requiredResourceFile must be specified for this feature."
    exit 1
fi

pwsh -f install.ps1