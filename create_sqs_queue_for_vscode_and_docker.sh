#!/bin/bash

export QUEUE=$(aws sqs create-queue --queue-name "test-$(uuidgen)" --attributes ReceiveMessageWaitTimeSeconds=20 --query QueueUrl --output text)

cat appsettings.Development.json | jq ".queues.main=env.QUEUE" > appsettings.Development.json.tmp
mv appsettings.Development.json.tmp appsettings.Development.json

cat docker_run_app.sh | awk '{gsub(/'"https\:\/\/sqs.*"'/,"'$QUEUE\''")}1' > docker_run_app.sh.tmp
mv docker_run_app.sh.tmp docker_run_app.sh
