#!/bin/bash

set -e
# shellcheck disable=SC1091
source dev-container-features-test-lib

check "k9s Installed" k9s version | grep 0.26.6

reportResults
