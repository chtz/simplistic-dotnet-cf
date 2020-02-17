#!/bin/bash
ACCOUNT=$(aws sts get-caller-identity --profile admin-hslu --query Account --output text)
REGION=$(aws configure get region --profile admin-hslu)
aws ecr get-login-password --profile admin-hslu | docker login --username AWS --password-stdin https://$ACCOUNT.dkr.ecr.$REGION.amazonaws.com
