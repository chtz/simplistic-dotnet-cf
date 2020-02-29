# .NET Core goes AWS Fargate

## What is this?

- Focus: An AWS CloudFormation template that allows you to run a dockerized Hello World application in ECS Fargate
- Sample workload: A simple Hello World AspNetCore app (one of my first .NET Core applications, btw.) that talks to MS SQL Server and logs in "CloudWatch Logs Insights-friendly" JSON
- A few bash scripts so that you do not have to leave the console

## AWS stuff covered

- CloudFormation: Infrastructure-as-Code
- Application Load Balancer: Managed HTTP reverse proxy
- AWS Fargate: Serverless compute for containers
- AWS Secrets Manager: Secure storage of RDS credentials and connection strings
- Amazon ECR: Managed private docker registry
- Amazon RDS for SQL server: Managed SQL server
- CloudWatch Logs: Managed Logging solution
- CloudWatch Logs Metric Filters: Convert error log patterns to CloudWatch error metrics
- CloudWatch Alarms: Alarm based on the occurrence of errors in the logs
- Simple Notification Service: Send error alerts to email subscribers 

## Preconditions

- AWS Account and default VPC
- Linux-like OS (e.g. macOS)
- AWS CLI v2 installed and configured (e.g. aws configure sso)
- Docker installed
- Tools for everyday use installed: bash, sed, curl, jq
- Optional: Visual Studio Code and .NET Core plugins installed

## Steps

Run app in Visual Studio Code:

    # Start DB
    ./docker_run_db.sh

    # Run app
    F5

    # Test app
    open https://localhost:5001/WeatherForecast

Run app with docker:

    # Start DB
    ./docker_run_db.sh

    # Optional: Manually interact with DB
    ./docker_run_db_sqlcmd.sh

    # Build and run app
    ./docker_build.sh
    ./docker_run_app.sh

    # Test app
    ./curl_app.sh

Run app in AWS:

    # Ensure you are targeting the correct AWS account
    export AWS_PROFILE=<your-aws-cli-profile>

    # Create private docker image repository (ECR)
    ./create_stack_ecr.sh
    
    # Create ALB, ECS cluster & task definition & service (desired count=0), RDS instance and Security Groups (in default VPC) 
    ./create_stack_application.sh

    # Optional: Subscribe to error log alerts
    ./topic_subscribe.sh <your-email>

    # Build .NET service and docker image, push image to ECR
    ./ecr_dockerlogin.sh
    ./docker_build.sh
    ./ecr_dockerpush.sh 

    # Set desired count to 1 (-> deploy dockerized .NET service -> run app)
    ./update_stack_application.sh

    # Send HTTP request to service (see also CloudWatch logs for .NET service log output: RDS query results)
    ./curl_stack_application.sh

    # Don't forget to delete all AWS resources after testing (to keep the AWS bill low)
    ./delete_stack_application.sh 
    ./delete_stack_ecr.sh

Enjoy!
