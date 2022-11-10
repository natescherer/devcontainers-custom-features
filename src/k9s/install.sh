#!/bin/sh
set -e

repo="derailed/k9s"
filenameTemplate="k9s_Linux_ARCH.tar.gz"
binaryName="k9s"

find_github_release_asset_url() {
    local repo=$1
    local filenameTemplate=$2
    local version=$3
    local versionPrefix=${4:-"v"}

    if [ "$version" = "latest" ]; then
        local releaseUrl="https://api.github.com/repos/${repo}/releases/latest"
    else
        local releaseUrl="https://api.github.com/repos/${repo}/releases/tags/${versionPrefix}${version}"
    fi
    archRegex="$(dpkg --print-architecture)"
    if [ "$archRegex" = "amd64" ]; then
        archRegex="(amd64|x64|x86_64)"
    fi

    local filenameRegex=$(echo "$filenameTemplate" | sed "s/VERSION/$version/" | sed "s/ARCH/$arch/")
    local downloadUrl=$(curl -H "Accept: application/vnd.github+json" -s ${releaseUrl} | jq -r -c ".assets[] | select(.name|test(\"$filenameRegex\")) | .browser_download_url")

    echo $downloadUrl
}

download_and_install_gzipped_tarball() {
    local url=$1
    local destFolder=$2
    local binaryName=$3

    local installTempPath=/tmp/$binaryName
    local tarballName=$(echo "$url" | rev | cut -d'/' -f1 | rev)

    echo "Installing $url to $destFolder..."

    mkdir -p "$installTempPath" "$destFolder"
    curl -sSL -o "$installTempPath/$tarballName" "$url"
    tar xf "$installTempPath/$tarballName" -C "$destFolder"
    ln -s "$destFolder/$binaryName" "/usr/local/bin/$binaryName"
    rm -rf "$installTempPath"
}

ghUrl="$(find_github_release_asset_url $repo $filenameTemplate $VERSION)"

echo "$ghUrl"

download_and_install_gzipped_tarball $ghUrl /opt/$binaryName $binaryName