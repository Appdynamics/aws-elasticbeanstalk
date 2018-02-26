#!/bin/bash

APP_NAME="appd-java"
ENV_NAME="appd-test-env-1"
KEY="aws-eb-yoga"
REGION="us-west-2"
INSTANCE="t2.micro"
PLATFORM="java"
BASE_DIR="/home/michi/workspace"

cd $BASE_DIR
rm -rf spring-music
git clone https://github.com/cloudfoundry-samples/spring-music
cd spring-music
eb init $APP_NAME -p $PLATFORM -r $REGION -k $KEY
echo "build: gradle clean assemble" >> Buildfile
echo 'web: java -Dserver.port=8080 -Dspring.profiles.active=in-memory -jar build/libs/spring-music.jar' >> Procfile
mkdir .ebextensions
cp -r /home/michi/Documents/business/appd/dev/aws/aws-elasticbeanstalk/java/.ebextensions/nginx ./.ebextensions
cp /home/michi/Documents/business/appd/dev/aws/aws-elasticbeanstalk/java/.ebextensions/appd_bashrc.config ./.ebextensions
git add ./
git commit -m "eb"
eb create --timeout 15 $ENV_NAME -i $INSTANCE
eb terminate $ENV_NAME --force
