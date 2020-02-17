#!/bin/bash

IMAGES_TO_DELETE=$(aws ecr list-images --profile admin-hslu --repository-name myimage --query 'imageIds[*]' --output json)
aws ecr batch-delete-image --profile admin-hslu --repository-name myimage --image-ids "$IMAGES_TO_DELETE" || true

aws cloudformation delete-stack --profile admin-hslu --stack-name myservice
aws cloudformation wait stack-delete-complete --profile admin-hslu --stack-name myservice
