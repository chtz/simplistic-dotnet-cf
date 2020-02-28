#!/bin/bash

SERVICE=${1:-weatherforecast}

DEFAULT_VPC_ID=$(aws ec2 describe-vpcs --query 'Vpcs[?IsDefault==`true`].VpcId' --output text)
SUBNET_IDS=$(aws ec2 describe-subnets --query "Subnets[?VpcId==\`$DEFAULT_VPC_ID\`].SubnetId" --output text | sed 's/[[:space:]]/,/g')

aws cloudformation create-stack --stack-name $SERVICE-application --template-body file://./cf/application.yaml \
    --capabilities CAPABILITY_IAM \
    --parameters ParameterKey=Subnets,ParameterValue=\"$SUBNET_IDS\" \
                 ParameterKey=VPC,ParameterValue=$DEFAULT_VPC_ID \
                 ParameterKey=ServiceName,ParameterValue=$SERVICE \
                 ParameterKey=ECRRepositoryName,ParameterValue=$SERVICE

aws cloudformation wait stack-create-complete --stack-name $SERVICE-application
