#!/bin/bash
REPO_URI=$(aws ecr describe-repositories --repository-name myimage --query "repositories[].repositoryUri" --output text --profile admin-hslu)
docker tag myimage:latest $REPO_URI:latest
docker push $REPO_URI:latest
