# .NET Core goes AWS Fargate

## What is this?

- Focus ("everything else are side dishes"): An AWS CloudFormation template that allows you to run a dockerized Hello World application in ECS Fargate (see cf/ecr.yaml and cf/application.yaml)
- Sample workload: A simple Hello World AspNetCore app (one of my first .NET Core applications, btw.) that talks to MS SQL Server (and SQS) and logs in "CloudWatch Logs Insights-friendly" JSON
- A few (bash-) scripts so that you do not have to leave the console

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
- Simple Notification Service: Used to send error alerts to email subscribers 
- Amazon Simple Queue Service: Process SQS messages via AWS SDK for .NET

## Preconditions

- AWS Account and default VPC (tested in eu-central-1)
- Linux-like OS (e.g. macOS - tested with Catalina)
- AWS CLI (v2) installed and profile configured (~admin permissions)
- Docker installed and running (e.g. Docker Desktop)
- Tools for everyday use installed (used in scripts): bash, sed, awk, curl, jq, ruby
- awslogs installed (pip3 install awslogs)
- Optional: Visual Studio Code and .NET Core plugins installed

## Steps

General tip (and disclaimer): Study all scripts (bash, ruby) and sources (C#) before you execute them. Basically they should work if all tools are installed and configured (see preconditions). 

Note, however, that the scripts (and obviously the app) are not intended for productive use (learning examples, e.g. the scripts do not include error handling).

Preperation:

    # Ensure you are targeting the correct AWS account
    export AWS_PROFILE=<your-aws-cli-profile>

    # Create SQS queue and update config in appsettings.Development.json (to run app in VS Code) and environment config in docker_run_app.sh (to run app with docker)
    ./create_sqs_queue_for_vscode_and_docker.sh

    # Update AWS profile in appsettings.Development.json
    ./update_vs_settings.sh 

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

    # Create private docker image repository (ECR)
    ./create_stack_ecr.sh
    
    # Create ALB, ECS cluster & task definition & service (desired count=0), RDS instance and Security Groups (in default VPC), etc.
    ./create_stack_application.sh

    # Optional: Subscribe to error log alerts
    ./topic_subscribe.sh <your-email>

    # Build .NET service and docker image, push image to ECR
    ./docker_build.sh
    ./ecr_dockerlogin.sh
    ./ecr_dockerpush.sh 

    # Set desired count to 1 ("deploy" dockerized .NET service)
    ./update_stack_application.sh

    # Send HTTP request to service
    ./curl_stack_application.sh
   
    # CloudWatch Logs Insighs sample: Show recent info logs (somewhat delayed)
    ./logs_insights_stack_application.sh

    # awslogs sample: "tail -f" error and critical logs
    ./logs_watch_stack_application.sh

    # Don't forget to delete all AWS resources after testing (to keep the AWS bill low)
    ./delete_stack_application.sh 
    ./delete_stack_ecr.sh

Enjoy!
