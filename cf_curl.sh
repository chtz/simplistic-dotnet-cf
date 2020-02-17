#!/bin/bash

LB_URL=$(aws cloudformation describe-stacks --profile admin-hslu --stack-name myservice --query "Stacks[0].Outputs[?OutputKey=='LoadBalancer'].OutputValue" --output text)

curl -s http://$LB_URL/WeatherForecast | jq .
