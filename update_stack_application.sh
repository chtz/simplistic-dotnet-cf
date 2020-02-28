#!/bin/bash

SERVICE=${1:-weatherforecast}
DOCKER_TAG=${2:-latest}

aws cloudformation update-stack --stack-name $SERVICE-application --template-body file://./cf/application.yaml \
    --capabilities CAPABILITY_IAM \
    --parameters ParameterKey=Subnets,UsePreviousValue=true \
                 ParameterKey=VPC,UsePreviousValue=true \
                 ParameterKey=ServiceName,UsePreviousValue=true \
                 ParameterKey=ECRRepositoryName,UsePreviousValue=true \
                 ParameterKey=DockerImageTag,ParameterValue=$DOCKER_TAG \
                 ParameterKey=DesiredCount,ParameterValue=1

aws cloudformation wait stack-update-complete --stack-name $SERVICE-application
