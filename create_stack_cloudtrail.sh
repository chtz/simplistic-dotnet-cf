#!/bin/bash

aws cloudformation create-stack --stack-name cloudtrail --template-body file://./cf/cloudtrail.yaml \
    --capabilities CAPABILITY_IAM

aws cloudformation wait stack-create-complete --stack-name cloudtrail
