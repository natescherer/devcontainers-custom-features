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

check_alpine_packages() {
    apk add -v --no-cache "$@"
}

check_packages() {
	if ! dpkg -s "$@" >/dev/null 2>&1; then
		if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
			echo "Running apt-get update..."
			apt-get update -y
		fi
		apt-get -y install --no-install-recommends "$@"
	fi
}

ensure_prereqs() {
    check_packages libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev curl git ca-certificates
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
        -c core.eol=lf \
        -c core.autocrlf=false \
        -c fsck.zeroPaddedFilemode=ignore \
        -c fetch.fsck.zeroPaddedFilemode=ignore \
        -c receive.fsck.zeroPaddedFilemode=ignore \
        "https://github.com/asdf-vm/asdf.git" --branch v0.12.0 $ASDF_BASEPATH 2>&1
EOF

    if cat /etc/os-release | grep "ID_LIKE=.*alpine.*\|ID=.*alpine.*" ; then
        echo "Updating /etc/profile"
        echo -e "export ASDF_DIR=\"$ASDF_BASEPATH\"" >>/etc/profile
        echo -e ". $ASDF_BASEPATH/asdf.sh" >>/etc/profile
    fi
    if [[ "$(cat /etc/bash.bashrc)" != *"$ASDF_BASEPATH"* ]]; then
        echo "Updating /etc/bash.bashrc"
        echo -e ". $ASDF_BASEPATH/asdf.sh" >>/etc/bash.bashrc
        echo -e ". $ASDF_BASEPATH/completions/asdf.bash" >>/etc/bash.bashrc
    fi
    if [ -f "/etc/zsh/zshrc" ] && [[ "$(cat /etc/zsh/zshrc)" != *"$ASDF_BASEPATH"* ]]; then
        echo "Updating /etc/zsh/zshrc"
        echo -e ". $ASDF_BASEPATH/asdf.sh" >>/etc/zsh/zshrc
        echo -e "fpath=(\${ASDF_DIR}/completions \$fpath)" >>/etc/zsh/zshrc
        echo -e "autoload -Uz compinit && compinit" >>/etc/zsh/zshrc
    fi
    # if command -v pwsh & >/dev/null && ( [[ "$(cat /opt/microsoft/powershell/7/profile.ps1)" != *"$ASDF_BASEPATH"* ]] || [ ! -f "/opt/microsoft/powershell/7/profile.ps1" ] ); then
    #     if [ -f "/opt/microsoft/powershell/7/profile.ps1" ]; then
    #         echo "Updating /opt/microsoft/powershell/7/profile.ps1"
    #     else
    #         touch /opt/microsoft/powershell/7/profile.ps1
    #     fi
    #     echo -e ". $ASDF_BASEPATH/asdf.ps1" >>/opt/microsoft/powershell/7/profile.ps1
    # fi
    if [ -f "/etc/fish/config.fish" ] && [[ "$(cat /etc/fish/config.fish)" != *"$ASDF_BASEPATH"* ]]; then
        echo "Updating /etc/fish/config.fish"
        echo -e "source $ASDF_BASEPATH/asdf.fish" >>/etc/fish/config.fish
        ln -s $ASDF_BASEPATH/completions/asdf.fish /etc/fish/completions
    fi
}

install_via_asdf() {
	PLUGIN=$1
    VERSION=$2
    LATESTVERSIONPATTERN="[0-9]"

	set -e
	
    su - "$_REMOTE_USER" <<EOF
        . $_REMOTE_USER_HOME/.asdf/asdf.sh

        if asdf list "$PLUGIN" >/dev/null 2>&1; then
            echo "$PLUGIN  already exists - skipping adding it"
        else
            asdf plugin add "$PLUGIN" "$REPO" 
        fi

        if [ -n "$REQUIREMENTSFILE" ]; then
            ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$REQUIREMENTSFILE"
        fi

        asdf install "$PLUGIN" "$VERSION"
        asdf global "$PLUGIN" "$VERSION"

        pip install --upgrade pip

        python -m pip install --user pipx
        python -m pipx ensurepath
EOF
}

# Ensure the prereqs for asdf and building python are installed
ensure_prereqs

# Install asdf and its requirements (if needed)
ensure_asdf_is_installed

# Install Python versions
set -- $VERSIONS
while [ -n "$1" ]; do
    PLUGINNAME="python"
    VERSION="latest:$1"

	install_via_asdf "$PLUGINNAME" "$VERSION" ""
	shift
done

# Install supporting tools
su - "$_REMOTE_USER" <<EOF
    . $_REMOTE_USER_HOME/.asdf/asdf.sh

    if ! type pipx >/dev/null 2>&1; then
        if asdf list pipx >/dev/null 2>&1; then
            echo "pipx already exists - skipping adding it"
        else
            asdf plugin add pipx
        fi

        asdf install pipx latest
        asdf global pipx latest
    fi

    pipx install cookiecutter
    pipx install poetry
    pipx install nox
    pipx inject nox nox-poetry
EOF