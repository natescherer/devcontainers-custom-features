
# asdf package (asdf-package)

Installs an asdf package.

## Example Usage

```json
"features": {
    "ghcr.io/devcontainers-contrib/features/asdf-package:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| plugin | Select the asdf plugin to install. | string | - |
| version | Select the version of the asdf plugin to install. | string | latest |
| pluginRepo | Select the asdf plugin repo to install (can remain empty in order to use the plugin short-name index https://github.com/asdf-vm/asdf-plugins) | string | - |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/devcontainers-contrib/features/blob/main/src/asdf-package/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
