#!/bin/bash

# Pre-cond: CloudTrail must be enabled!

HOSTED_ZONE_ID=${1?param missing - hosted zone id.}

aws cloudformation create-stack --stack-name acm-auto-validator --template-body file://./cf/acm_auto_validator.yaml \
    --capabilities CAPABILITY_IAM \
    --parameters ParameterKey=HostedZoneId,ParameterValue=\"$HOSTED_ZONE_ID\"

aws cloudformation wait stack-create-complete --stack-name acm-auto-validator
