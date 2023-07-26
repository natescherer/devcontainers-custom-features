#!/bin/bash

set -e

source dev-container-features-test-lib


check "asdf list rabbitmq" asdf list rabbitmq
check "type rabbitmqctl" type rabbitmqctl


reportResults