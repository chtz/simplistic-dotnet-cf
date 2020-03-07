#!/bin/bash

aws cloudformation create-stack --stack-name acm-wildcard --template-body file://./cf/acm.yaml

aws cloudformation wait stack-create-complete --stack-name acm-wildcard
