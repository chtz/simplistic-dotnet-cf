#!/bin/bash

aws cloudformation create-stack --stack-name vpc --template-body file://./cf/vpc.yaml

aws cloudformation wait stack-create-complete --stack-name vpc
