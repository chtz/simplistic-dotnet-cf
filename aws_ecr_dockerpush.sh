#!/bin/bash
DOCKER_TAG=${1:-latest}
REPO_URI=$(aws ecr describe-repositories --repository-name myimage --query "repositories[].repositoryUri" --output text --profile admin-hslu)
docker tag myimage:latest $REPO_URI:$DOCKER_TAG
docker push $REPO_URI:$DOCKER_TAG
