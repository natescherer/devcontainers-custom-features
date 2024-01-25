<!-- markdownlint-disable MD041 -->

## Need to Install Specific Resource Versions?

Use `requiredResourceJsonBase64` or `requiredResourceJsonFile`; the RequiredResource spec allows defining specific package versions.

## Why `requiredResourceJsonBase64` is a Base64 string

Features are bash scripts at heart, and bash has a bad time handling JSON in environment variables, which are how inputs are passed to features. Base64-encoding ended up being the simplest, most easily reversible way to encode the data, though use of requiredResourceFile is probably a better option.

## Supported Linux Versions

This feature is tested and supported on Debian and Ubuntu-based development containers.
