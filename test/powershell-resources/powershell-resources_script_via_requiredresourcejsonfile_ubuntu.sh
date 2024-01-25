#!/bin/bash

set -e
# shellcheck disable=SC1091
source dev-container-features-test-lib

# shellcheck disable=SC2016
check "Assert-SameFile Latest" pwsh -c '$Results = Get-InstalledPSResource -Scope AllUsers -Name Assert-SameFile; if (!$Results) { throw }'

reportResults
