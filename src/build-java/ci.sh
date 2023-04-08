#!/usr/bin/env bash

ACTION=$1

ECR_CONTAINER_REGISTRY_URL="$AWS_DOMAIN_OWNER_ID.dkr.ecr.us-east-2.amazonaws.com"

if [[ -z "$ACTION" ]]; then
  echo "No command specified, available commands [build, test, publish, deploy]"
  exit 1
fi

chmod +x gradlew
REPO_NAME=${PWD##*/}

function codeArtifactLogin() {
    echo "Logging into CodeArtifact"
    export CODEARTIFACT_AUTH_TOKEN=`aws codeartifact get-authorization-token --domain promotion --domain-owner $AWS_DOMAIN_OWNER_ID --region us-east-2 --query authorizationToken --output text`
    if [[ ! -z "$CODEARTIFACT_AUTH_TOKEN" ]]; then
      echo "Login into CodeArtifact succeeded"
    else
      echo "Failed to login into CodeArtifact"
      exit 1
    fi
}

function runBuild() {
  codeArtifactLogin

  echo "Building..."
  ./gradlew build
}

function runTest() {
  codeArtifactLogin

  echo "Running tests..."
  ./gradlew test
}

function publishArtifacts() {
  codeArtifactLogin

  echo "Publishing artifacts..."
  ./gradlew publish
}

function deploy() {
  echo "Deploying..."
  local image_name="$ECR_CONTAINER_REGISTRY_URL/$REPO_NAME:latest"
  ./gradlew bootBuildImage --imageName "$ECR_CONTAINER_REGISTRY_URL/$REPO_NAME:latest"
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
