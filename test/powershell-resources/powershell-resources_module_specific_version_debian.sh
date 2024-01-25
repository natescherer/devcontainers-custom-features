#!/bin/bash

set -e
# shellcheck disable=SC1091
source dev-container-features-test-lib

pwsh -c 'Get-PSResource -Scope AllUsers'
# shellcheck disable=SC2016
check "ChangelogManagement 2.1.3" pwsh -c '$Results = Get-PSResource -Scope AllUsers -Name ChangelogManagement -Version 2.1.3.0; if (!$Results) { throw }'

reportResults
