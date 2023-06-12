#!/bin/sh
set -e

echo "Feature 'python-packages' starting..."

if ! command -v pip > /dev/null; then
    echo "Pip is not installed. Please ensure it is installed before using this feature."
    exit 127
fi

if [ "$PACKAGES" != "" ] && [ "$REQUIREMENTSFILE" != "" ]; then
    echo "You cannot specify both packages and requirementsFile for this feature."
    exit 1
fi

if [ -z "$PACKAGES" ] && [ -z "$REQUIREMENTSFILE" ]; then
    echo "An input must be specified for this feature."
    exit 1
fi

if [ "$PACKAGES" != "" ]; then
    pip install $PACKAGES
fi

if [ "$REQUIREMENTSFILE" != "" ]; then
    pip install -r $REQUIREMENTSFILE
fi