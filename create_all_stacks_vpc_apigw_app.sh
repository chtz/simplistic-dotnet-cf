#!/bin/bash

./create_stack_vpc.sh
./create_stack_apigw_nlb.sh 
./create_stack_application.sh 
