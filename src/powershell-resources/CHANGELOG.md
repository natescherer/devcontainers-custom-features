# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Fixed
- Action now ensures that NuGet package provider is installed
- Test to ensure PowerShellGet is up-to-date now works properly

## [1.1.0] - 2023-08-02
### Added
- Test for requiredResourceJsonFile
- Test for upgrading Microsoft.PowerShell.PSResourceGet prerelease versions

### Changed
- Moved all tests out of _global
- Pinned to Microsoft.PowerShell.PSResourceGet 0.5.23-beta23
- install.sh now tests if PowerShellGet is 2.2.5 and only upgrades if necessary
- install.sh now tests if Microsoft.PowerShell.PSResourceGet is at least 0.5.23-beta23 and only upgrades if necessary

## [1.0.0] - 2022-11-04
### Added
- Input `resources`

### Changed
- Input `requiredResourceFile` is now `requiredResourceJsonFile`
- Input `requiredResourceBase64` is now `requiredResourceJsonBase64`
- Pinned to PowerShellGet 3.0 Preview 17 to avoid breaking issues

## [0.1.0] - 2022-10-19
### Added
- Initial release
