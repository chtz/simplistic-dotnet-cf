#!/bin/bash

#pre-cond: ./docker_run_db.sh

docker run -e 'ASPNETCORE_ConnectionStrings__main=Server=database;Database=tempdb;User Id=sa;Password=Password!123' -it --rm -p 8080:80 --link database myimage
