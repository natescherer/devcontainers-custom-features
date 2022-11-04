#!/bin/sh
set -e

echo "Feature 'powershell-resources' starting..."

if ! command -v pwsh > /dev/null; then
    echo "PowerShell is not installed. Please ensure it is installed before using this feature."
    exit 127
fi

if [ "$REQUIREDRESOURCEJSONBASE64" != "" ] && [ "$REQUIREDRESOURCEJSONFILE" != "" ]; then
    echo "You cannot specify both requiredResourceJsonBase64 and requiredResourceJsonFile for this feature."
    exit 1
fi

if [ "$RESOURCE" != "" ] && [ "$REQUIREDRESOURCEJSONFILE" != "" ]; then
    echo "You cannot specify both resource and requiredResourceJsonFile for this feature."
    exit 1
fi

if [ "$REQUIREDRESOURCEJSONBASE64" != "" ] && [ "$RESOURCE" != "" ]; then
    echo "You cannot specify both requiredResourceJsonBase64 and resource for this feature."
    exit 1
fi

if [ -z "$RESOURCE" ] && [ -z "$REQUIREDRESOURCEJSONBASE64" ] && [ -z "$REQUIREDRESOURCEJSONFILE" ]; then
    echo "An input must be specified for this feature."
    exit 1
fi

pwsh -f install.ps1