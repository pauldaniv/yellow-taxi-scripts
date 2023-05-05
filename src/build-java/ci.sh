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
if [[ -f service.txt ]]; then
  SERVICE_NAME=$(cat service.txt)
else
  SERVICE_NAME=$REPO_NAME
fi

commit_hash=$(git rev-parse --short HEAD)
git_branch=${GITHUB_REF#refs/heads/}

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
  local image_name="$ECR_CONTAINER_REGISTRY_URL/$REPO_NAME"
  echo "Building '$image_name' docker image..."
  ./gradlew bootBuildImage --imageName "$image_name"

  local versioned_tag="$image_name:$commit_hash"
  local latest_tag="$image_name:latest"

  echo "Tagging '$image_name' with '$versioned_tag' and '$latest_tag'"
  docker tag "$image_name" "$versioned_tag"
  docker tag "$image_name" "$latest_tag"

  echo "Pushing '$versioned_tag' and '$latest_tag' docker image..."
  docker push $versioned_tag
  docker push $latest_tag

  echo "Pushed!"
}

function deploy() {
  echo "Deploying..."
  echo "Checkout manifests and update image version"
  local MANIFESTS_REPO_NAME="yellow-taxi-manifests"
  local MANIFESTS_REPO_URL="https://pauldaniv:$MANIFESTS_SHARED_TOKEN@github.com/pauldaniv/${MANIFESTS_REPO_NAME}"

  git clone --single-branch --depth 1 --branch main "${MANIFESTS_REPO_URL}"

  cd $MANIFESTS_REPO_NAME
  git remote -v
  echo $commit_hash
  sed "s/versionTag:.*/versionTag: $commit_hash/g" -i values/${SERVICE_NAME}.yaml
  #todo: remove debug
  cat values/${SERVICE_NAME}.yaml
  git config user.name "github_workflow_$REPO_NAME"
  git config user.email "github_workflow_$REPO_NAME"
  git add values/${SERVICE_NAME}.yaml
  git commit -m "Auto-deploy: $SERVICE_NAME, commit: $commit_hash"
#  git remote add origin "https://$MANIFESTS_SHARED_TOKEN@@github.com/pauldaniv/${MANIFESTS_REPO_NAME}"
  git push --force origin HEAD
  echo "Deployed!"
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
