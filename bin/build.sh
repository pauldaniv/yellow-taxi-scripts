#!/usr/bin/env bash

GITHUB_CONTAINER_REGISTRY_URL="ghcr.io/pauldaniv/yellow-taxi-scripts"
ECR_CONTAINER_REGISTRY_URL="375158168967.dkr.ecr.us-east-2.amazonaws.com"

function build_and_push_image() {
  local default_repo=ECR_CONTAINER_REGISTRY_URL
  local image=$1
  local repo=${2:-default_repo}
  local image_tag="$repo/$image:latest"
  echo "Building '$image_tag'..."
  docker build $BUILD_OPTS -t image_tag "src/$image"
  echo "Pushing '$image_tag' image..."
  docker push $image_tag
}

cd "$(cd "$(dirname "$0")/.."; pwd)"

BUILD_OPTS="--no-cache"
BUILD_OPTS="${BUILD_OPTS} --build-arg AWS_ACCESS_KEY_ID"
BUILD_OPTS="${BUILD_OPTS} --build-arg AWS_SECRET_ACCESS_KEY"

build_and_push_image "base"
build_and_push_image "build"

echo "Logging to ECR..."
aws ecr get-login-password --region us-east-2\
 | docker login --username AWS --password-stdin 375158168967.dkr.ecr.us-east-2.amazonaws.com

if [[ $? != 0 ]]; then
  echo "Unable to login to ECR"
  exit 1
else
  echo "Login to ECR succeeded!"
fi

for image in $(ls src | grep -v 'base' | grep -v 'build'); do
  build_and_push_image $image
done
