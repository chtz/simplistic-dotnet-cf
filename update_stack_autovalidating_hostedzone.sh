#!/bin/bash

aws cloudformation update-stack --stack-name autovalidating-hostedzone --template-body file://./cf/autovalidating_hostedzone.yaml \
    --capabilities CAPABILITY_IAM \
    --parameters ParameterKey=Domain,UsePreviousValue=true

aws cloudformation wait stack-update-complete --stack-name autovalidating-hostedzone
