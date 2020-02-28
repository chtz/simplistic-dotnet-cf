#!/bin/bash

SERVICE=${1:-weatherforecast}

IMAGES_TO_DELETE=$(aws ecr list-images --repository-name $SERVICE --query 'imageIds[*]' --output json)
aws ecr batch-delete-image --repository-name $SERVICE --image-ids "$IMAGES_TO_DELETE" || true

aws cloudformation delete-stack --stack-name $SERVICE-ecr
aws cloudformation wait stack-delete-complete --stack-name $SERVICE-ecr
