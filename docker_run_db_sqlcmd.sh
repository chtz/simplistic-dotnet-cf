#!/bin/bash

docker exec -it database /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'Password!123'
