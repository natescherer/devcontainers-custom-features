#!/bin/bash

set -e
source dev-container-features-test-lib

check "k9s Installed" k9s version | grep 0.26.6

reportResults