#!/bin/bash

aws cloudformation update-stack --profile admin-hslu --stack-name mydb --template-body file://./cf/database.yml \
    --parameters    ParameterKey=Subnets,UsePreviousValue=true \
                    ParameterKey=VPC,UsePreviousValue=true

aws cloudformation wait stack-update-complete --profile admin-hslu --stack-name mydb
