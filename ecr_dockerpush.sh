#!/bin/bash

SERVICE=${1:-weatherforecast}
DOCKER_TAG=${2:-latest}

REPO_URI=$(aws ecr describe-repositories --repository-name $SERVICE --query "repositories[].repositoryUri" --output text)

docker tag myimage:latest $REPO_URI:$DOCKER_TAG
docker push $REPO_URI:$DOCKER_TAG
