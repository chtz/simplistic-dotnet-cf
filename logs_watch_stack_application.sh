#!/bin/bash

SERVICE=${1:-weatherforecast}

LOG_GROUP=/ecs/$SERVICE

awslogs get /ecs/weatherforecast ALL --watch --filter-pattern '{ $.Level = "Error"  || $.Level = "Fatal" }' --query "{time:Timestamp, message:MessageTemplate}"

#Samples
#./logs_watch_stack_application.sh | sed -l 's/^[^ ][^ ]* [^ ][^ ]* //' | jq -r '"\(.time) \(.message)"' --unbuffered
