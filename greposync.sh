#!/bin/bash

set -xeo pipefail

version=${1}

install_gsync() {
  if [[ ! -d "$RUNNER_TOOL_CACHE" ]]; then
      echo "Cache directory '$RUNNER_TOOL_CACHE' does not exist" >&2
      exit 1
  fi

  local arch
  arch=$(uname -m)

  local cache_dir="$RUNNER_TOOL_CACHE/gsync/$version/$arch"
  if [[ ! -d "$cache_dir" ]]; then
    local download_dir=$(mktemp -d)
    mkdir -p "$cache_dir" "$download_dir"

    echo "Installing greposync..."
    curl -sSLo $download_dir/gsync_linux_amd64 "https://github.com/ccremer/greposync/releases/download/$version/gsync_linux_amd64"
    curl -sSLo $download_dir/checksums.txt "https://github.com/ccremer/greposync/releases/download/$version/checksums.txt"
    grep "$(sha256sum $download_dir/gsync_linux_amd64 | cut -f 1 -d ' ')  gsync_linux_amd64" $download_dir/checksums.txt
    chmod +x $download_dir/gsync_linux_amd64
    mv $download_dir/gsync_linux_amd64 $cache_dir/gsync
    rm -r $download_dir

    echo 'Adding gsync directory to PATH...'
    export PATH="$cache_dir:$PATH"
  fi
}

run() {
  gsync ${2}
}

install_gsync
run
