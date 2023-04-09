#!/usr/bin/env bash

IMAGE_NAME=$1
GITHUB_CONTAINER_REGISTRY_URL="ghcr.io/pauldaniv/yellow-taxi-scripts"

function get_version() {
  local path_to_version_file=$1
  [[ -f src/${path_to_version_file}/version.txt ]] && cat src/${path_to_version_file}/version.txt || cat version.txt
}
