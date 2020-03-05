#!/bin/bash

# Pre-cond: CloudTrail must be enabled!

DOMAIN=${1?param missing - DNS domain.}

aws cloudformation create-stack --stack-name autovalidating-hostedzone --template-body file://./cf/autovalidating_hostedzone.yaml \
    --capabilities CAPABILITY_IAM \
    --parameters ParameterKey=Domain,ParameterValue=\"$DOMAIN\"

aws cloudformation wait stack-create-complete --stack-name autovalidating-hostedzone

DNS_NAME_SERVERS=$(aws cloudformation describe-stacks --stack-name autovalidating-hostedzone --query "Stacks[0].Outputs[?OutputKey=='NameServers'].OutputValue" --output text)

echo "Please register your name servers!"
echo "DNS domain: $DOMAIN"
echo "DNS name servers: $DNS_NAME_SERVERS"
