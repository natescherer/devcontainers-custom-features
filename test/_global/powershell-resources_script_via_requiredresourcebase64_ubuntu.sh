#!/bin/bash

set -e
source dev-container-features-test-lib

pwsh -c 'Get-PSResource | fl'
check "New-OnPremiseHybridWorker Latest" pwsh -c 'Get-PSResource -Name New-OnPremiseHybridWorker' | grep 'New-OnPremiseHybridWorker'

reportResults