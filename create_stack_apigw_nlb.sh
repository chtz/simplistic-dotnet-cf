#!/bin/bash

DEFAULT_VPC_ID=$(aws ec2 describe-vpcs --query 'Vpcs[?IsDefault==`true`].VpcId' --output text)
SUBNET_IDS=$(aws ec2 describe-subnets --query "Subnets[?VpcId==\`$DEFAULT_VPC_ID\`].SubnetId" --output text | sed 's/[[:space:]]/,/g')

aws cloudformation create-stack --stack-name apigw-nlb --template-body file://./cf/apigw_nlb.yaml \
    --parameters ParameterKey=Subnets,ParameterValue=\"$SUBNET_IDS\" \
                 ParameterKey=VPC,ParameterValue=$DEFAULT_VPC_ID

aws cloudformation wait stack-create-complete --stack-name apigw-nlb

COGNITO_DOMAIN=$(aws cloudformation describe-stacks --stack-name apigw-nlb --query "Stacks[0].Outputs[?OutputKey=='CognitoAppWebDomain'].OutputValue" --output text)
COGNITO_CLIENT_ID=$(aws cloudformation describe-stacks --stack-name apigw-nlb --query "Stacks[0].Outputs[?OutputKey=='CognitoUserPoolClientId'].OutputValue" --output text)

cat <<EOT > webapp/js/config.js
var COGNITO_AUTH_DATA = { 
  ClientId: '$COGNITO_CLIENT_ID',
  AppWebDomain: '$COGNITO_DOMAIN',
  TokenScopesArray: ['openid'],
  RedirectUriSignIn: 'https://' + location.host + '/', 
  RedirectUriSignOut: 'https://' + location.host + '/'
};
EOT

WEB_BUCKET=$(aws cloudformation describe-stacks --stack-name apigw-nlb --query "Stacks[0].Outputs[?OutputKey=='WebBucket'].OutputValue" --output text)

aws s3 cp webapp/index.html s3://$WEB_BUCKET/index.html --acl public-read
aws s3 cp webapp/js s3://$WEB_BUCKET/js --recursive --acl public-read

WEB=$(aws cloudformation describe-stacks --stack-name apigw-nlb --query "Stacks[0].Outputs[?OutputKey=='WebURL'].OutputValue" --output text)

echo Go to $WEB
