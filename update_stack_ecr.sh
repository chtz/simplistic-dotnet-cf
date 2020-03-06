#!/bin/bash

SERVICE=${1:-weatherforecast}

aws cloudformation update-stack --stack-name $SERVICE-ecr --template-body file://./cf/ecr.yaml \
    --parameters ParameterKey=ECRRepositoryName,UsePreviousValue=true 

aws cloudformation wait stack-update-complete --stack-name $SERVICE-ecr
