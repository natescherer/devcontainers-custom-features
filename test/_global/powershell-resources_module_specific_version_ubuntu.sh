#!/bin/bash

set -e
source dev-container-features-test-lib

check "Logging" pwsh -c 'Get-PSResource -Name ChangelogMangement'
check "ChangelogManagement Latest" pwsh -c 'Get-PSResource -Name ChangelogMangement' | grep '2.1.3'

reportResults