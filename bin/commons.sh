#!/usr/bin/env bash

IMAGE_NAME=$1
GITHUB_CONTAINER_REGISTRY_URL="ghcr.io/pauldaniv/yellow-taxi-scripts"

function get_version() {
  cat version.txt
}
