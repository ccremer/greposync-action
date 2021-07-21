#!/bin/bash

set -eo pipefail

version=${1}
args=${2}

download_base_url="https://github.com/ccremer/greposync/releases"
if [[ $version == "latest" ]]; then
  version_url="$download_base_url/latest/download"
else
  version_url="$download_base_url/download/$version"
fi

install_gsync() {
  if [[ ! -d "$RUNNER_TOOL_CACHE" ]]; then
      echo "❌ Cache directory '$RUNNER_TOOL_CACHE' does not exist" >&2
      exit 1
  fi

  echo ::group::Installing greposync
  local cache_dir="$RUNNER_TOOL_CACHE/gsync/$version/amd64"
  if [[ ! -d "$cache_dir" ]]; then
    local download_dir=$(mktemp -d)
    mkdir -p "$cache_dir" "$download_dir"

    echo "⬇️ Downloading greposync..."
    pushd $download_dir
    curl -sSLo gsync_linux_amd64 "$version_url/gsync_linux_amd64"
    curl -sSLo checksums.txt "$version_url/checksums.txt"
    echo "🔒 Verifying download..."
    grep "$(sha256sum gsync_linux_amd64 | cut -f 1 -d ' ')  gsync_linux_amd64" checksums.txt
    echo "🧹 Cleaning up downloads..."
    chmod +x gsync_linux_amd64
    mv gsync_linux_amd64 $cache_dir/gsync
    popd
    rm -r $download_dir

    echo "⚙️ Adding gsync directory to PATH..."
    export PATH="$cache_dir:$PATH"
  fi
  echo ::endgroup::
  gsync --version
}

install_gsync
gsync ${args}
