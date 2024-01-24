#!/bin/bash

set -e
source dev-container-features-test-lib

check "Assert-SameFile Latest" pwsh -c '$Results = Get-InstalledPSResource -Scope AllUsers -Name Assert-SameFile; if (!$Results) { throw }'

reportResults