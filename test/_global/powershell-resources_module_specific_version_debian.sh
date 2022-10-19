#!/bin/bash

set -e
source dev-container-features-test-lib

check "Logging" pwsh -c 'Get-PSResource -Name ChangelogMangement'
check "ChangelogManagement 2.1.3" pwsh -c 'Get-PSResource -Name ChangelogMangement' | grep '2.1.3'

reportResults