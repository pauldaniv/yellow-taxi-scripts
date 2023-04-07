#!/usr/bin/env bash

chmod +x gradlew
./gradlew test

ECR_CONTAINER_REGISTRY_URL="375158168967.dkr.ecr.us-east-2.amazonaws.com"
echo "building..."
ls
./gradlew bootBuildImage --imageName "$ECR_CONTAINER_REGISTRY_URL/`basename`:latest"
