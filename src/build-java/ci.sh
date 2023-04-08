#!/usr/bin/env bash

# While running on GitHub actions the ~/.docker/config.json file for docker
# is not visible as the home folder is changed from /home/root to a different one
# that's why we have to copy the config file on flight before trying to access ECR

mkdir -p $HOME/.docker/
cp /home/root/.docker/config.json $HOME/.docker/config.json

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
  echo "Published!"
}

function pushDockerImage() {
  local image_name="$ECR_CONTAINER_REGISTRY_URL/$REPO_NAME:latest" #todo: add commit hash
  echo "Building '$image_name' docker image..."
  ./gradlew bootBuildImage --imageName "$image_name"
  echo "Push '$image_name' docker image..."
  docker push $image_name
  echo "Pushed!"
}

function deploy() {
  echo "Deploying..."
  #todo: update manifests
}

if [[ "$ACTION" = "build" ]]; then
  runBuild
elif [[ "$ACTION" = "test" ]]; then
  runTest
elif [[ "$ACTION" = "publish" ]]; then
    publishArtifacts
elif [[ "$ACTION" = "deploy" ]]; then
  pushDockerImage
  deploy
else
  echo "Unknown command $ACTION"
  exit 1
fi
