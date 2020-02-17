#!/bin/bash

DOCKER_TAG=${1:-latest}

aws cloudformation update-stack --profile admin-hslu --stack-name myservice --template-body file://./cf/fargate.yml \
    --capabilities CAPABILITY_IAM \
    --parameters    ParameterKey=Subnets,UsePreviousValue=true \
                    ParameterKey=VPC,UsePreviousValue=true \
                    ParameterKey=DockerImageTag,ParameterValue=$DOCKER_TAG \
                    ParameterKey=DesiredCount,ParameterValue=1

aws cloudformation wait stack-update-complete --profile admin-hslu --stack-name myservice
