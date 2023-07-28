#!/bin/bash

set -e
source dev-container-features-test-lib

check "python 3.10" asdf list python 3.10
check "python 3.11" asdf list python 3.11

check "cookiecutter" cookiecutter --version
check "poetry" poetry --version
check "nox" nox --version
check "nox-poetry" pipx list --include-injected | grep nox-poetry

reportResults