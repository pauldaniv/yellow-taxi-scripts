#!/usr/bin/env bash

BUILD_OPTS="--no-cache"

GITHUB_CONTAINER_REGISTRY_URL="ghcr.io/pauldaniv/yellow-taxi-scripts"

BASE_IMAGES=( "base" "terraform" )

function build_and_push_image() {
    local image=$1
    local repo=$2
    local image_tag="$repo/$image:latest"
    echo "Building '$image_tag'..."
    docker build $BUILD_OPTS -t "$image_tag" "src/$image"
    echo "Pushing '$image_tag' image..."
    docker push $image_tag
}

function build_and_push_top_level_image() {
  build_and_push_image "$image" "$GITHUB_CONTAINER_REGISTRY_URL"
}

cd "$(cd "$(dirname "$0")/.."; pwd)"

for image in $(ls src); do
  build_and_push_top_level_image $image
done
