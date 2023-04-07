#!/usr/bin/env bash

BUILD_OPTS="--no-cache"
BUILD_OPTS="${BUILD_OPTS} --build-arg AWS_ACCESS_KEY_ID"
BUILD_OPTS="${BUILD_OPTS} --build-arg AWS_SECRET_ACCESS_KEY"

GITHUB_CONTAINER_REGISTRY_URL="ghcr.io/pauldaniv/yellow-taxi-scripts"
ECR_CONTAINER_REGISTRY_URL="375158168967.dkr.ecr.us-east-2.amazonaws.com"

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
  build_and_push_image "$image" "$ECR_CONTAINER_REGISTRY_URL"
}

function build_and_push_second_level_image() {
  build_and_push_image "$image" "$GITHUB_CONTAINER_REGISTRY_URL"
}

cd "$(cd "$(dirname "$0")/.."; pwd)"

echo "Building base images..."
for image in "${BASE_IMAGES[@]}"; do
  build_and_push_top_level_image $image
done

echo "Logging to ECR..."
aws ecr get-login-password --region us-east-2\
 | docker login --username AWS --password-stdin 375158168967.dkr.ecr.us-east-2.amazonaws.com

if [[ $? != 0 ]]; then
  echo "Unable to login to ECR"
  exit 1
else
  echo "Login to ECR succeeded!"
fi

for image in $(ls src); do
  if [[ ! " ${BASE_IMAGES[*]} " =~ " ${image} " ]]; then
    build_and_push_second_level_image $image
  fi
done
