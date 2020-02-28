#!/bin/bash

SERVICE=${1:-weatherforecast}

aws cloudformation delete-stack --stack-name $SERVICE-application
aws cloudformation wait stack-delete-complete --stack-name $SERVICE-application
