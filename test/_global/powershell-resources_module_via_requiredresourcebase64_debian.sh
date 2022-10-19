#!/bin/bash

set -e
source dev-container-features-test-lib

check "ChangelogManagement Latest" pwsh -c 'Get-PSResource -Name ChangelogMangement' | grep 'ChangelogManagement'

reportResults