#!/bin/bash

set -e
source dev-container-features-test-lib

pwsh -c 'Get-PSResource | fl'
check "ChangelogManagement 2.1.3" pwsh -c 'Get-PSResource -Name ChangelogMangement' | grep '2.1.3'

reportResults