#!/bin/bash

SERVICE=${1:-weatherforecast}

aws cloudformation create-stack --stack-name $SERVICE-ecr --template-body file://./cf/ecr.yaml \
    --parameters ParameterKey=ECRRepositoryName,ParameterValue=$SERVICE

aws cloudformation wait stack-create-complete --stack-name $SERVICE-ecr
