#!/bin/bash

# Replace queue URL in appsettings.Development.json
cat appsettings.Development.json | jq ".AWS.Profile=env.AWS_PROFILE" > appsettings.Development.json.tmp
mv appsettings.Development.json.tmp appsettings.Development.json
