#!/bin/bash
aws ecr describe-repositories --repository-name myimage --query "repositories[].repositoryUri" --output text --profile admin-hslu
