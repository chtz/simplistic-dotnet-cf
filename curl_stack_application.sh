#!/bin/bash

SERVICE=${1:-weatherforecast}

URL=$(aws cloudformation describe-stacks --stack-name apigw-nlb --query "Stacks[0].Outputs[?OutputKey=='WebURL'].OutputValue" --output text)

echo "curl -v -s $URL"
curl -v -s $URL
