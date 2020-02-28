#!/bin/bash

ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
REGION=$(aws configure get region)

aws ecr get-login-password  | docker login --username AWS --password-stdin https://$ACCOUNT.dkr.ecr.$REGION.amazonaws.com
