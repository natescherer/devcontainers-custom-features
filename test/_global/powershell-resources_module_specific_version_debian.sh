#!/bin/bash

set -e
source dev-container-features-test-lib

pwsh -c 'Get-PSResource -Scope AllUsers'
check "ChangelogManagement 2.1.3" pwsh -c '$Results = Get-PSResource -Scope AllUsers -Name ChangelogMangement -Version 2.1.3; if (!$Results) { throw }'

reportResults