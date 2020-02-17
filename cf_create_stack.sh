#!/bin/bash

DEFAULT_VPC_ID=$(aws ec2 describe-vpcs --profile admin-hslu --query 'Vpcs[?IsDefault==`true`].VpcId' --output text)
SUBNET_IDS=$(aws ec2 describe-subnets --profile admin-hslu --query "Subnets[?VpcId==\`$DEFAULT_VPC_ID\`].SubnetId" --output text | sed 's/[[:space:]]/,/g')

aws cloudformation create-stack --profile admin-hslu --stack-name myservice --template-body file://./cf/fargate.yml \
    --capabilities CAPABILITY_IAM \
    --parameters    ParameterKey=Subnets,ParameterValue=\"$SUBNET_IDS\" \
                    ParameterKey=VPC,ParameterValue=$DEFAULT_VPC_ID

aws cloudformation wait stack-create-complete --profile admin-hslu --stack-name myservice
