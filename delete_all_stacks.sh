#!/bin/bash

SERVICE=${1:-weatherforecast}

aws cloudformation delete-stack --stack-name $SERVICE-application
aws cloudformation wait stack-delete-complete --stack-name $SERVICE-application

WEB_BUCKET=$(aws cloudformation describe-stacks --stack-name apigw-nlb --query "Stacks[0].Outputs[?OutputKey=='WebBucket'].OutputValue" --output text)
aws s3 rm s3://$WEB_BUCKET --recursive

aws cloudformation delete-stack --stack-name apigw-nlb
aws cloudformation wait stack-delete-complete --stack-name apigw-nlb

aws cloudformation delete-stack --stack-name vpc
aws cloudformation wait stack-delete-complete --stack-name vpc
