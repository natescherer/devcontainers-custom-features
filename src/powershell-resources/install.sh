#!/bin/sh
set -e

echo "Feature 'powershell-resources' starting..."

if ! command -v pwsh >/dev/null; then
  echo "PowerShell is not installed. Please ensure it is installed before using this feature."
  exit 127
fi

if [ "$REQUIREDRESOURCEJSONBASE64" != "" ] && [ "$REQUIREDRESOURCEJSONFILE" != "" ]; then
  echo "You cannot specify both requiredResourceJsonBase64 and requiredResourceJsonFile for this feature."
  exit 1
fi

if [ "$RESOURCES" != "" ] && [ "$REQUIREDRESOURCEJSONFILE" != "" ]; then
  echo "You cannot specify both resources and requiredResourceJsonFile for this feature."
  exit 1
fi

if [ "$REQUIREDRESOURCEJSONBASE64" != "" ] && [ "$RESOURCES" != "" ]; then
  echo "You cannot specify both requiredResourceJsonBase64 and resources for this feature."
  exit 1
fi

if [ -z "$RESOURCES" ] && [ -z "$REQUIREDRESOURCEJSONBASE64" ] && [ -z "$REQUIREDRESOURCEJSONFILE" ]; then
  echo "An input must be specified for this feature."
  exit 1
fi

pwsh -f install.ps1
