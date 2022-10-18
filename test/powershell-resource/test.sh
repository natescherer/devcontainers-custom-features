#!/bin/bash

set -e
source dev-container-features-test-lib

if ! command -v pwsh &> /dev/null; then
    check "pwsh missing" powershell-resource | grep 'PowerShell is not installed'
else
    check "no options" powershell-resource | grep 'Either requiredResource or requiredResourceFile'
fi


reportResults