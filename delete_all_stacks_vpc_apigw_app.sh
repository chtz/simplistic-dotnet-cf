#!/bin/bash

./delete_stack_application.sh

WEB_BUCKET=$(aws cloudformation describe-stacks --stack-name apigw-nlb --query "Stacks[0].Outputs[?OutputKey=='WebBucket'].OutputValue" --output text)
aws s3 rm s3://$WEB_BUCKET --recursive
aws cloudformation delete-stack --stack-name apigw-nlb
aws cloudformation wait stack-delete-complete --stack-name apigw-nlb
#Brute force approach to mitigate expected delete issues during first attempt
#Expected (delete events): Load balancer 'arn:aws:elasticloadbalancing:eu-central-1:028619293920:loadbalancer/net/apigw-LoadB-1NWQYK1Y35QQ5/81e20350e21f1511' cannot be deleted because it is currently associated with another service (Service: AmazonElasticLoadBalancingV2; Status Code: 400; Error Code: ResourceInUse; Request ID: c8aa145e-6c46-4948-8473-7e655a54e95d)
#Expected (delete events): Cannot delete vpc link. Vpc link '7rg6hf', is referenced in [GET:nuuah0:deployment] in format of [Method:Resource:Stage]. (Service: AmazonApiGateway; Status Code: 400; Error Code: BadRequestException; Request ID: 3f15097c-0fb3-4223-8064-b24f67169a50)
#Expected (wait cli result): Waiter StackDeleteComplete failed: Waiter encountered a terminal failure state
aws cloudformation delete-stack --stack-name apigw-nlb
aws cloudformation wait stack-delete-complete --stack-name apigw-nlb

aws cloudformation delete-stack --stack-name vpc
aws cloudformation wait stack-delete-complete --stack-name vpc
