#!/bin/bash

set -e
source dev-container-features-test-lib

# There should be a test here for PowerShell not being installed in the container, but, due to limitations in the test suite, it's not currently writeable.
check "no options" powershell-resource | grep 'Either requiredResource or requiredResourceFile'

reportResults