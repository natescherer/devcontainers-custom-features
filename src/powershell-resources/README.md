
# PowerShell Resources (powershell-resources)

A feature to install PowerShell resources (modules and scripts) from the PowerShell Gallery for all users on a devcontainer.

## Example Usage

```json
"features": {
    "ghcr.io/natescherer/devcontainers-custom-features/powershell-resources:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| resources | A comma-seprated string listing the names of one or more resources available in the PowerShell Gallery to install. | string | - |
| requiredResourceJsonBase64 | Base64-encoded JSON defining one or more resources (and, optionally, their versions) to install. See https://github.com/PowerShell/PowerShellGet/blob/master/help/Install-PSResource.md#notes for JSON format, and use a tool like https://www.base64encode.org/ to encode. | string | - |
| requiredResourceJsonFile | Path to a JSON file inside the container defining one or more resources (and, optionally, their versions) to install. See https://github.com/PowerShell/PowerShellGet/blob/master/help/Install-PSResource.md#notes for format of this file. | string | - |

## Need to Install Specific Resource Versions?

Use `requiredResourceJsonBase64` or `requiredResourceJsonFile`; the RequiredResource spec allows defining specific package versions.

## Why `requiredResourceJsonBase64` is a Base64 string

Features are bash scripts at heart, and bash has a bad time handling JSON in environment variables, which are how inputs are passed to features. Base64-encoding ended up being the simplest, most easily reversible way to encode the data, though use of requiredResourceFile is probably a better option.

## Supported Linux Versions

This feature is tested and supported on Debian and Ubuntu-based development containers.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/natescherer/devcontainers-custom-features/blob/main/src/powershell-resources/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
