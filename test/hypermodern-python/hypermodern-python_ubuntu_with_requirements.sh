#!/bin/bash

set -e
# shellcheck disable=SC1091
source dev-container-features-test-lib

check "python 3.11" asdf list python 3.11

check "cookiecutter" cookiecutter --version
check "poetry" poetry --version
check "nox" nox --version
pipx list --include-injected --json >/tmp/pipxlist.json
check "nox-poetry" yq '.venvs.nox.metadata.injected_packages | has("nox-poetry")' /tmp/pipxlist.json -o json -e

check "requests installed" pip list | grep -F requests

reportResults
