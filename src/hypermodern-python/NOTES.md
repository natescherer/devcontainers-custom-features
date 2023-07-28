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
