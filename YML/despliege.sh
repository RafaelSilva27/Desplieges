#! /bin/bash
STACK_NAME=awsbootstrap
REGION=us-east-1
CLI_PROFILE=default

InstanceType=t2.micro

echo -e "\n=========== Desplegando  main.yml ================="

aws cloudformation deploy \
	--region us-east-1 \
	--profile default \
	--stack-name awsbootstrap \
	--template-file main.yml \
	--no-fail-on-empty-changeset \
	--capabilities CAPABILITY_NAMED_IAM \
	--parameter-override EC2InstanceType=$EC2_INSTANCE_TYPE