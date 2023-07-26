#!/bin/bash

set -e

source dev-container-features-test-lib


check "asdf list act" asdf list act


reportResults
