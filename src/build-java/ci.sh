#!/usr/bin/env bash

ACTION=$1

ECR_CONTAINER_REGISTRY_URL="375158168967.dkr.ecr.us-east-2.amazonaws.com"

if [[ -z "$ACTION" ]]; then
  echo "No command specified, available commands [build, test, publish, deploy]"
  exit 1
fi

chmod +x gradlew

function runBuild() {
  echo "Building..."
  ./gradlew build
}

function runTest() {
  echo "Running tests..."
  ./gradlew test
}

function publishArtifacts() {
  echo "Publishing artifacts..."
  ./gradlew deploy --imageName "$ECR_CONTAINER_REGISTRY_URL/`basename`:latest"
}

function deploy() {
  echo "Deploying..."
  local image_name="$ECR_CONTAINER_REGISTRY_URL/`basename`:latest"
  ./gradlew bootBuildImage --imageName "$ECR_CONTAINER_REGISTRY_URL/`basename`:latest"
  docker push $image_name
}


if [[ "$ACTION" = "build" ]]; then
  runBuild
elif [[ "$ACTION" = "test" ]]; then
  runTest
elif [[ "$ACTION" = "publish" ]]; then
    publishArtifacts
elif [[ "$ACTION" = "deploy" ]]; then
  deploy
else
  echo "Unknown command $ACTION"
  exit 1
fi
