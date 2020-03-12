#!/bin/bash

aws cloudformation update-stack --stack-name vpc --template-body file://./cf/vpc.yaml

aws cloudformation wait stack-update-complete --stack-name vpc
