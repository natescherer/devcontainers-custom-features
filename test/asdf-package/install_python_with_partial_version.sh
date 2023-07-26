#!/bin/bash

set -e

source dev-container-features-test-lib


check "asdf list python" asdf list python


reportResults
