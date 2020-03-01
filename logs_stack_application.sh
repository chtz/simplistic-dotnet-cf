#!/bin/bash

PERIOD_HOURS=${1:-0.1}
LEVEL_FILTER=${2:-"Level=='Information'"}
SERVICE=${3:-weatherforecast}

LOG_GROUP=/ecs/$SERVICE
QUERY="fields @timestamp, @message | sort @timestamp asc | filter $LEVEL_FILTER"

#./logs_insights.rb $PERIOD_HOURS "$LOG_GROUP" "$QUERY" 2>/dev/null
./logs_insights.rb $PERIOD_HOURS "$LOG_GROUP" "$QUERY"

#Samples:
#./logs_stack_application.sh 1 "Level=='Error'" | jq
#./logs_stack_application.sh 2 "\\\`Properties.Request.User-Agent\\\` !== 'ELB-HealthChecker/2.0'" | jq -r '"\(.Timestamp) \(.Properties.Request["X-Amzn-Trace-Id"]) \(.MessageTemplate), Id=\(.Properties.Id)"'
