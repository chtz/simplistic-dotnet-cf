#!/bin/bash

#pre-cond: ./docker_run_db.sh

docker run -v ~/.aws:/root/.aws \
    -e "AWS_PROFILE=$AWS_PROFILE" \
    -e 'ASPNETCORE_ConnectionStrings__main=Server=database;Database=tempdb;User Id=sa;Password=Password!123' \
    -e 'ASPNETCORE_queues__main=https://eu-central-1.queue.amazonaws.com/028619293920/test-AF205FF2-E369-42B6-AE6F-B71D151E39AB' \
    -it --rm -p 8080:80 --link database myimage
