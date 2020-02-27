#!/bin/bash
docker run --name database -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Password!123' -p 1433:1433 -d mcr.microsoft.com/mssql/server:2017-latest
