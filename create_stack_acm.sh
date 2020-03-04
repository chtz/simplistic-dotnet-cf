#!/bin/bash

echo "Start: $(date)"

aws cloudformation create-stack --stack-name acm-cert2 --template-body file://./cf/acm.yaml \
    --capabilities CAPABILITY_IAM

aws cloudformation wait stack-create-complete --stack-name acm-cert2

echo "Stop: $(date)"
