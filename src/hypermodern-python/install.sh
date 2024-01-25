#!/bin/bash -i
set -ex

VERSIONS=${VERSIONS:-""}
REQUIREMENTSFILE=${REQUIREMENTSFILE:-""}

# Clean up
rm -rf /var/lib/apt/lists/*

if [ -z "$VERSIONS" ]; then
  echo -e "'versions' variable is empty, skipping"
  exit 0
fi

if [ "$(id -u)" -ne 0 ]; then
  echo -e 'Script must be run as
    root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
  exit 1
fi

check_packages_with_apt-get() {
  if ! dpkg -s "$@" >/dev/null 2>&1; then
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
      echo "Running apt-get update..."
      apt-get update -yq
    fi
    apt-get install -yq -o Dpkg::Progress-Fancy="0" -o Dpkg::Use-Pty="0" --no-install-recommends "$@"
  fi
}

ensure_prerequisites() {
  check_packages_with_apt-get libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev curl git ca-certificates

  if ! type yq >/dev/null 2>&1; then
    ARCHITECTURE="$(uname -m)"
    case ${ARCHITECTURE} in
      x86_64) ARCHITECTURE="amd64" ;;
      aarch64 | armv8*) ARCHITECTURE="arm64" ;;
      aarch32 | armv7* | armvhf*) ARCHITECTURE="arm" ;;
      i?86) ARCHITECTURE="386" ;;
      *)
        echo "(!) Architecture ${ARCHITECTURE} unsupported"
        exit 1
        ;;
    esac
    echo "Installing yq..."
    wget -q https://github.com/mikefarah/yq/releases/latest/download/yq_linux_$ARCHITECTURE -O /usr/bin/yq
    chmod +x /usr/bin/yq
  else
    echo "'yq' is already installed"
  fi
}

ensure_asdf_is_installed() {
  ASDF_BASEPATH="$_REMOTE_USER_HOME/.asdf"

  set -e
  su - "$_REMOTE_USER" <<EOF
		if type asdf >/dev/null 2>&1; then
			exit
		elif [ -f "$ASDF_BASEPATH/asdf.sh" ]; then
            exit
        fi

        git clone --depth=1 \
        -c advice.detachedHead=false \
        -c core.eol=lf \
        -c core.autocrlf=false \
        -c fsck.zeroPaddedFilemode=ignore \
        -c fetch.fsck.zeroPaddedFilemode=ignore \
        -c receive.fsck.zeroPaddedFilemode=ignore \
        "https://github.com/asdf-vm/asdf.git" --branch v0.12.0 $ASDF_BASEPATH 2>&1
EOF

  if ! grep -q -s "$ASDF_BASEPATH" "/etc/bash.bashrc"; then
    echo "Updating /etc/bash.bashrc"
    echo -e ". $ASDF_BASEPATH/asdf.sh" >>/etc/bash.bashrc
    echo -e ". $ASDF_BASEPATH/completions/asdf.bash" >>/etc/bash.bashrc
  fi
  if [ -f "/etc/zsh/zshrc" ] && ! grep -q "$ASDF_BASEPATH" "/etc/zsh/zshrc"; then
    echo "Updating /etc/zsh/zshrc"
    {
      echo -e ". $ASDF_BASEPATH/asdf.sh"
      # shellcheck disable=SC2016
      echo -e 'fpath=(${ASDF_DIR}/completions $fpath)'
      echo -e "autoload -Uz compinit && compinit"
    } >>/etc/zsh/zshrc
  fi
  if command -v pwsh &>/dev/null && (! grep -q "$ASDF_BASEPATH" "/opt/microsoft/powershell/7/profile.ps1" || [ ! -f "/opt/microsoft/powershell/7/profile.ps1" ]); then
    if [ -f "/opt/microsoft/powershell/7/profile.ps1" ]; then
      echo "Updating /opt/microsoft/powershell/7/profile.ps1"
    else
      touch /opt/microsoft/powershell/7/profile.ps1
    fi
    echo -e ". $ASDF_BASEPATH/asdf.ps1" >>/opt/microsoft/powershell/7/profile.ps1
  fi
  if [ -f "/etc/fish/config.fish" ] && ! grep -q "$ASDF_BASEPATH" "/etc/fish/config.fish"; then
    echo "Updating /etc/fish/config.fish"
    echo -e "source $ASDF_BASEPATH/asdf.fish" >>/etc/fish/config.fish
    ln -s "$ASDF_BASEPATH/completions/asdf.fish" /etc/fish/completions
  fi
}

ensure_asdf_plugin_is_installed() {
  PLUGIN=$1

  su - "$_REMOTE_USER" <<EOF
    . $_REMOTE_USER_HOME/.asdf/asdf.sh

    if asdf list "$PLUGIN" >/dev/null 2>&1; then
        echo "'$PLUGIN' asdf plugin already exists - skipping adding it"
    else
        asdf plugin add $PLUGIN
    fi
EOF
}

install_python_via_asdf() {
  VERSION=$1

  set -e

  su - "$_REMOTE_USER" <<EOF
    . $_REMOTE_USER_HOME/.asdf/asdf.sh

    if [ -n "$REQUIREMENTSFILE" ]; then
        echo "Setting variable ASDF_PYTHON_DEFAULT_PACKAGES_FILE to $REQUIREMENTSFILE"
        export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$REQUIREMENTSFILE"
    fi

    asdf install python "$VERSION"
    asdf global python "$VERSION"

    pip install --upgrade pip
EOF
}

ensure_supporting_tools_are_installed() {
  su - "$_REMOTE_USER" <<EOF
    . $_REMOTE_USER_HOME/.asdf/asdf.sh

    ensure_pipx_app_is_installed() {
        PIPX_APP=\$1

        if ! type \$PIPX_APP >/dev/null 2>&1; then
            echo "Installing '\$PIPX_APP' via pipx..."
            pipx install "\$PIPX_APP"
        else
            echo "'\$PIPX_APP' is already installed"
        fi
    }

    ensure_pipx_injection() {
        ENV=\$1
        INJECTION=\$2

        if ! pipx list --include-injected --json | yq '.venvs.strenv(ENV).metadata.injected_packages | has("strenv(INJECTION)")' -o json; then
            echo "Injecting '\$INJECTION' into '\$ENV' via pipx..."
            pipx inject \$ENV \$INJECTION
        else
            echo "'\$ENV' already has '\$INJECTION' injected"
        fi

    }

    if ! type pipx >/dev/null 2>&1; then
        if asdf list pipx >/dev/null 2>&1; then
            echo "'pipx' asdf plugin already exists - skipping adding it"
        else
            asdf plugin add pipx
        fi
        echo "Installing 'pipx' via asdf..."
        asdf install pipx latest
        asdf global pipx latest
        pipx ensurepath
    else
        echo "pipx is already installed"
    fi

    ensure_pipx_app_is_installed cookiecutter
    ensure_pipx_app_is_installed poetry
    ensure_pipx_app_is_installed nox
    ensure_pipx_injection nox nox-poetry
    # pipx install cookiecutter
    # pipx install poetry
    # pipx install nox
    # pipx inject nox nox-poetry
EOF
}

# Ensure the prerequisites for asdf and building python are installed
echo "Installing prerequisites..."
ensure_prerequisites

# Install asdf and its requirements (if needed)
echo "Ensuring asdf is installed..."
ensure_asdf_is_installed

# Add python asdf plugin, if needed
echo "Adding asdf python plugin..."
ensure_asdf_plugin_is_installed "python"

# Install Python versions
# shellcheck disable=SC2086
set -- $VERSIONS
while [ -n "$1" ]; do
  VERSION="latest:$1"

  echo "Installing python version $VERSION..."

  install_python_via_asdf "$VERSION"
  shift
done

# Install Hypermodern Python supporting tools
echo "Installing supporting tools..."
ensure_supporting_tools_are_installed
