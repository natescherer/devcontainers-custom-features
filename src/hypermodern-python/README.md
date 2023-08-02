
# Hypermodern Python (hypermodern-python)

A feature to install multiple Python versions via asdf along with the tools needed to create Hypermodern Python projects. (https://github.com/cjolowicz/cookiecutter-hypermodern-python)

## Example Usage

```json
"features": {
    "ghcr.io/natescherer/devcontainers-custom-features/hypermodern-python:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| versions | A space separated list of Python major versions to install and configure. | string | 3.10 3.11 |
| requirementsFile | A fully-qualified path to a requirements.txt file inside the container which will be installed for every Python version. | string | - |

# About this Feature

This feature is designed to set up multiple versions of Python via [asdf](https://asdf-vm.com), and install the following supporting tools needed to use the [Hypermodern Python Cookiecutter](https://cookiecutter-hypermodern-python.readthedocs.io):

- [Cookiecutter](https://github.com/audreyr/cookiecutter)
- [Poetry](https://python-poetry.org/)
- [Nox](https://nox.thea.codes/)
- [nox-poetry](https://nox-poetry.readthedocs.io/)

# Notes

- This feature will install asdf as the dev container remoteUser and configure profiles and autocompletions for all of the following shells: bash, zsh, fish, PowerShell
- The last Python version provided in the `versions` list will be set as the global version in asdf by default, though this can be changed afterwards.

# Credits

Portions of the code for this feature have been adapted from [https://github.com/devcontainers-contrib/features/tree/main/src/asdf-package](https://github.com/devcontainers-contrib/features/tree/main/src/asdf-package)

## Supported Linux Versions

This feature is tested and supported on Debian and Ubuntu-based development containers. It may work on other Linux versions, but is currently untested.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/natescherer/devcontainers-custom-features/blob/main/src/hypermodern-python/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
