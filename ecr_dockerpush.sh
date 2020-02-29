#!/bin/bash

DOCKER_TAG=${1:-latest}
SERVICE=${2:-weatherforecast}

REPO_URI=$(aws ecr describe-repositories --repository-name $SERVICE --query "repositories[].repositoryUri" --output text)

docker tag myimage:latest $REPO_URI:$DOCKER_TAG
docker push $REPO_URI:$DOCKER_TAG
