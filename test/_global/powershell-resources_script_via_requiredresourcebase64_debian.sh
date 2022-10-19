#!/bin/bash

set -e
source dev-container-features-test-lib

pwsh -c 'Get-PSResource -Scope AllUsers'
check "New-OnPremiseHybridWorker Latest" pwsh -c 'Get-PSResource -Scope AllUsers -Name New-OnPremiseHybridWorker' | grep 'New-OnPremiseHybridWorker'

reportResults