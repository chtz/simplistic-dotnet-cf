#!/bin/bash

SERVICE=${1:-weatherforecast}

LB_URL=$(aws cloudformation describe-stacks --stack-name $SERVICE-application --query "Stacks[0].Outputs[?OutputKey=='LoadBalancer'].OutputValue" --output text)

echo "curl -v -s https://$LB_URL/WeatherForecast"
curl -v -s https://$LB_URL/WeatherForecast 
