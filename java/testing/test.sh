#!/bin/bash

APP_NAME="appd-java"
ENV_NAME="appd-test-env-1"
KEY="aws-eb-yoga"
REGION="us-west-2"
INSTANCE="t2.micro"
PLATFORM=$(echo $PWD | sed -e 's/.*aws-elasticbeanstalk\/\(\w*\)-*.*\/testing.*/\1/g')
BEANSTALK_DIR=$(echo $PWD | sed -e 's/\(.*aws-elasticbeanstalk\)\/.*/\1/g')
BASE_DIR="/home/michi/workspace"

cd $BASE_DIR
rm -rf spring-music
git clone https://github.com/cloudfoundry-samples/spring-music
cd spring-music
eb init $APP_NAME -p $PLATFORM -r $REGION -k $KEY
echo "build: gradle clean assemble" >> Buildfile
echo 'web: java -Dserver.port=8080 -Dspring.profiles.active=in-memory -jar build/libs/spring-music.jar' >> Procfile
mkdir .ebextensions
cp -r $BEANSTALK_DIR/_common/.ebextensions/nginx ./.ebextensions
cp $BEANSTALK_DIR/$PLATFORM/.ebextensions/appd.config ./.ebextensions
git add ./
git commit -m "eb"
eb create --timeout 15 $ENV_NAME -i $INSTANCE
#eb terminate $ENV_NAME --force
