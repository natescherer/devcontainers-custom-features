## Why `requiredResourceBase64` is a Base64 string

Features are bash scripts at heart, and bash has a bad time handling JSON in environment variables, which are how inputs are passed to features. Base64-encoding ended up being the simplest, most easily reversible way to encode the data, though use of requiredResourceFile is probably a better option.

## Supported Linux Versions

This feature is currently only tested and supported on Debian and Ubuntu-based development containers, as that is what is supported by the [official PowerShell feature](https://github.com/devcontainers/features/tree/main/src/powershell). This may work on Alpine if you install PowerShell on it another way, but is not supported. (If the official PowerShell feature adds support for Alpine at some point, I will add testing and support to this feature. Please open an Issue if this has happened and I have not yet realized.)
