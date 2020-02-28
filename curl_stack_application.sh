#!/bin/bash

SERVICE=${1:-weatherforecast}

LB_URL=$(aws cloudformation describe-stacks --stack-name $SERVICE-application --query "Stacks[0].Outputs[?OutputKey=='LoadBalancer'].OutputValue" --output text)

curl -s http://$LB_URL/WeatherForecast | jq .
