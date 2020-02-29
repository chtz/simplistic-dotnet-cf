#!/bin/bash

EMAIL=$1
SERVICE=${2:-weatherforecast}

TOPIC=$(aws cloudformation describe-stacks --stack-name $SERVICE-application --query "Stacks[0].Outputs[?OutputKey=='AlarmTopicArn'].OutputValue" --output text)

aws sns subscribe --topic-arn $TOPIC --protocol email --notification-endpoint $EMAIL
