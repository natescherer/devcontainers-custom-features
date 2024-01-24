#!/bin/bash

set -e
source dev-container-features-test-lib

pwsh -c 'Get-PSResource -Scope AllUsers'
check "Install-GithubRelease Latest" pwsh -c '$Results = Get-PSResource -Scope AllUsers -Name Install-GithubRelease; if (!$Results) { throw }'

reportResults