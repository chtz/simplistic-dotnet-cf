#!/bin/bash

# Caution: no error handling ;-)

# Create new SQS queue
export QUEUE=$(aws sqs create-queue --queue-name "test-$(uuidgen)" --attributes ReceiveMessageWaitTimeSeconds=20 --query QueueUrl --output text)

# Replace queue URL in appsettings.Development.json
cat appsettings.Development.json | jq ".queues.main=env.QUEUE" > appsettings.Development.json.tmp
mv appsettings.Development.json.tmp appsettings.Development.json

# Replace queue URL in docker_run_app.sh
cat docker_run_app.sh | awk '{gsub(/'"https\:\/\/sqs.*"'/,"'$QUEUE\'' \\")}1' > docker_run_app.sh.tmp
mv docker_run_app.sh.tmp docker_run_app.sh
chmod +x docker_run_app.sh
