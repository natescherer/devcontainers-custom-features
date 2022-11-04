#!/bin/bash

set -e
source dev-container-features-test-lib

pwsh -c 'Get-PSResource -Scope AllUsers'
check "New-OnPremiseHybridWorker Latest" pwsh -c '$Results = Get-PSResource -Scope AllUsers -Name New-OnPremiseHybridWorker; if (!$Results) { throw }'

reportResults