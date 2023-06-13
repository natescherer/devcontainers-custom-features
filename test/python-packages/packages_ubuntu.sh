#!/bin/bash

set -e
source dev-container-features-test-lib

check "requests installed" pip show requests

reportResults