#!/bin/bash

APP_NAME="appd-java"
ENV_NAME="appd-test-env-1"
KEY="aws-eb-yoga"
REGION="us-west-2"
INSTANCE="t2.micro"
PLATFORM="java"

eb init $APP_NAME -p $PLATFORM -r $REGION -k $KEY
eb create $ENV_NAME -i $INSTANCE
eb terminate $ENV_NAME --force
