#!/bin/bash

set -e
source dev-container-features-test-lib

pwsh -c 'Get-PSResource -Scope AllUsers'
check "ChangelogManagement" pwsh -c '$Results = Get-PSResource -Scope AllUsers -Name ChangelogManagement; if (!$Results) { throw }'
check "PoshEmail" pwsh -c '$Results = Get-PSResource -Scope AllUsers -Name ChangelogManagement; if (!$Results) { throw }'

reportResults