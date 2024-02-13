#!/bin/bash
set -e

VERSION=${VERSION:-""}

repo="derailed/k9s"
filenameTemplate="k9s_Linux_ARCH.tar.gz$"
binaryName="k9s"

find_github_release_asset_url() {
  local repo filenameTemplate version versionPrefix releaseUrl arch filenameRegex downloadUrl
  repo=$1
  filenameTemplate=$2
  version=$3
  versionPrefix=${4:-"v"}

  if [ "${version}" = "latest" ]; then
    releaseUrl="https://api.github.com/repos/${repo}/releases/latest"
  else
    releaseUrl="https://api.github.com/repos/${repo}/releases/tags/${versionPrefix}${version}"
  fi
  arch="$(dpkg --print-architecture)"
  if [ "${arch}" = "amd64" ]; then
    arch="(amd64|x64|x86_64)"
  fi

  filenameRegex=$(echo "$filenameTemplate" | sed "s/VERSION/${version}/" | sed "s/ARCH/${arch}/")
  downloadUrl=$(curl -H "Accept: application/vnd.github+json" -s "$releaseUrl" | jq -r -c ".assets[] | select(.name|test(\"${filenameRegex}\")) | .browser_download_url")

  echo "$downloadUrl"
}

download_and_install_tar_gz() {
  local url destFolder binaryName installTempPath tarballName
  url=$1
  destFolder=$2
  binaryName=$3

  installTempPath="/tmp/${binaryName}"
  tarballName=$(echo "$url" | rev | cut -d'/' -f1 | rev)

  echo "Installing $url to $destFolder..."

  mkdir -p "$installTempPath" "/opt/${binaryName}"
  curl -sSL -o "${installTempPath}/${tarballName}" "$url"
  tar xf "${installTempPath}/${tarballName}" -C "$destFolder"
  ln -s "${destFolder}/${binaryName}" "/usr/local/bin/${binaryName}"
  rm -rf "$installTempPath"
}

ghUrl=$(find_github_release_asset_url "$repo" "$filenameTemplate" "$VERSION")

download_and_install_tar_gz "$ghUrl" "/opt/${binaryName}" $binaryName
