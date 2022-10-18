# Dev Container Custom Features

## Contents

This repository contains a _collection_ of features. Each one is summarized below; for more details, see linked documentation.

### powershell-resource

Running `hello` inside the built container will print the greeting provided to it via its `greeting` option.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/devcontainers/feature-template/hello:1": {
            "greeting": "Hello"
        }
    }
}
```

```bash
$ hello

Hello, user.
```
