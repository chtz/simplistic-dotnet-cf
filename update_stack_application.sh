#!/bin/bash

DOCKER_TAG=${1:-latest}
SERVICE=${2:-weatherforecast}

aws cloudformation update-stack --stack-name $SERVICE-application --template-body file://./cf/application.yaml \
    --capabilities CAPABILITY_IAM \
    --parameters ParameterKey=ServiceName,UsePreviousValue=true \
                 ParameterKey=ECRRepositoryName,UsePreviousValue=true \
                 ParameterKey=DockerImageTag,ParameterValue=$DOCKER_TAG \
                 ParameterKey=DesiredCount,ParameterValue=1
#    --parameters ParameterKey=Subnets,UsePreviousValue=true \
#                 ParameterKey=VPC,UsePreviousValue=true \

aws cloudformation wait stack-update-complete --stack-name $SERVICE-application
