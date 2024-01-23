#! /bin/bash
STACK_NAME=awsbootstrap
REGION=us-east-1
CLI_PROFILE=default

aws cloudformation delete-stack \
    --region us-east-1 \
    --profile default \
    --stack-name awsbootstrap
