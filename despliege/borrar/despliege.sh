#!/bin/bash

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=
export AWS_DEFAULT_REGION=us-east-1

aws cloudformation deploy \
--template-file apache-tomcat-daweb/basic-stack-yaml/main.yml \
--stack-name "tomcat" \
--capabilities CAPABILITY_NAMED_IAM