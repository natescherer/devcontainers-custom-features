#!/bin/bash

set -e
# shellcheck disable=SC1091
source dev-container-features-test-lib

pwsh -c 'Get-PSResource -Scope AllUsers'
# shellcheck disable=SC2016
check "ChangelogManagement Latest" pwsh -c '$Results = Get-PSResource -Scope AllUsers -Name ChangelogManagement; if (!$Results) { throw }'

reportResults