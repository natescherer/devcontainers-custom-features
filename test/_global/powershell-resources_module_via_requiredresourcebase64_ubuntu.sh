#!/bin/bash

set -e
source dev-container-features-test-lib

pwsh -c 'Get-PSResource -Scope AllUsers | fl'
check "ChangelogManagement Latest" pwsh -c 'Get-PSResource -Scope AllUsers -Name ChangelogMangement' | grep 'ChangelogManagement'

reportResults