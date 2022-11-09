#!/bin/sh
set -e

find_github_release_asset_url() {
    local repo=$1
    local filenameTemplate=$2
    local version=$3
    local versionPrefix=${4:-"v"}

    if [ "${version}" = "latest" ]; then
        local releaseUrl="https://api.github.com/repos/${repo}/releases/latest"
    else
        local releaseUrl="https://api.github.com/repos/${repo}/releases/tags/${versionPrefix}${version}"
    fi
    arch="$(dpkg --print-architecture)"
    if [ "${arch}" = "amd64" ]; then
        arch="(amd64|x64|x86_64)"
    fi

    local filename=$(echo "$filenameTemplate" | sed "s/VERSION/$version/")
    filename=${filename/ARCH/"${arch}"}
    local downloadUrl=$(curl -H "Accept: application/vnd.github+json" -s ${releaseUrl} | jq -r -c ".assets[] | select(.name|test(\"${filename}\")) | .browser_download_url")

    echo $downloadUrl
}

download_and_install_gzipped_tarball() {
    local url=$1
    local destFolder=$2
    local binaryName=$3

    local installTempPath=/tmp/ghinstall
    local tarballName=$(echo "$url" | rev | cut -d'/' -f1 | rev)

    echo "Installing $url to $destFolder..."

    mkdir -p "$installTempPath" "/opt/$binaryName"
    curl -sSL -o "$installTempPath/$tarballName" "$url"
    tar xf "$installTempPath/$tarballName" -C "$destFolder"
    ln -s "$destFolder/$binaryName" "/usr/local/bin/$binaryName"
    rm -rf "$installTempPath"
}

ghUrl="$(find_github_release_asset_url derailed/k9s k9s_Linux_ARCH.tar.gz $VERSION)"

download_and_install_gzipped_tarball $ghUrl /opt/k9s k9s