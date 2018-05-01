#!/bin/bash

PLATFORM="java"
BEANSTALK_DIR=$(echo $PWD | sed -e 's/\(.*aws-elasticbeanstalk\)\/.*/\1/g')

function checkPrerequs {
  which eb &> /dev/null
  if [[ $? != 0 ]]; then
    echo "eb (elasticbeanstalk CLI) is not installed - exiting"
    exit 1
  fi
  which git &> /dev/null
  if [[ $? != 0 ]]; then
    echo "git is not installed - exiting"
    exit 1
  fi
}

function usage {
  echo -e "$0\t-a <APP_NAME> will be prompted if not provided\n\t\t\
  -b <BASE_DIR> will be prompted if not provided - The Sample App will be cloned to this dir\n\t\t\
  -e <ENV_NAME> will be prompted if not provided\n\t\t\
  -r <REGION> will be prompted if not provided\n\t\t\
  -i <INSTANCE> Optional - Default Instance will be used\n\t\t\
  -k <KEY> Optional - If not set no SSH key auth will be possible\n\t\t\
  -c <APPDYNAMICS_CONTROLLER_HOST_NAME> will be prompted if not provided\n\t\t\
  -p <APPDYNAMICS_CONTROLLER_PORT> will be prompted if not provided\n\t\t\
  -S <APPDYNAMICS_CONTROLLER_SSL_ENABLED>\n\t\t\
  -K <APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY> will be prompted if not provided\n\t\t"
  exit 1
}

function getOptions {
  while getopts ":a:e:k:r:i:b:c:p:S:K:h" opt;
  do
   case "${opt}" in
     a) APP_NAME=${OPTARG}
        echo "APP_NAME=${APP_NAME}"
        ;;
     e) ENV_NAME=${OPTARG}
        echo "ENV_NAME=${ENV_NAME}"
        ;;
     k) KEY=${OPTARG}
        echo "KEY=${KEY}"
        ;;
     r) REGION=${OPTARG}
        echo "REGION=${REGION}"
        ;;
     i) INSTANCE=${OPTARG}
        echo "INSTANCE=${INSTANCE}"
        ;;
     b) BASE_DIR=${OPTARG}
        echo "BASE_DIR=${BASE_DIR}"
        ;;
     c) APPDYNAMICS_CONTROLLER_HOST_NAME=${OPTARG}
        echo "APPDYNAMICS_CONTROLLER_HOST_NAME=${APPDYNAMICS_CONTROLLER_HOST_NAME}"
        ;;
     p) APPDYNAMICS_CONTROLLER_PORT=${OPTARG}
        echo "APPDYNAMICS_CONTROLLER_PORT=${APPDYNAMICS_CONTROLLER_PORT}"
        ;;
     S) APPDYNAMICS_CONTROLLER_SSL_ENABLED=${OPTARG}
        echo "APPDYNAMICS_CONTROLLER_SSL_ENABLED=${APPDYNAMICS_CONTROLLER_SSL_ENABLED}"
        ;;
     K) APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=${OPTARG}
        echo "APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=${APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY}"
        ;;
     h) usage
        ;;
     \?)  echo "ERROR: Invalid Argument -${OPTARG}"
          usage
          ;;
   esac
  done
}

function checkOptions {
  if [[ -z ${APP_NAME} ]]; then
    echo -e "APP_NAME not set please provide it:"
    read APP_NAME
  fi
  if [[ -z ${ENV_NAME} ]]; then
    echo -e "ENV_NAME not set please provide it:"
    read ENV_NAME
  fi
  if [[ -z ${BASE_DIR} ]]; then
    echo -e "BASE_DIR not set please provide it:"
    read BASE_DIR
  fi
  if [[ -z ${APPDYNAMICS_CONTROLLER_HOST_NAME} ]]; then
    echo -e "APPDYNAMICS_CONTROLLER_HOST_NAME not set please provide it:"
    read APPDYNAMICS_CONTROLLER_HOST_NAME
  fi
  if [[ -z ${APPDYNAMICS_CONTROLLER_PORT} ]]; then
    echo -e "APPDYNAMICS_CONTROLLER_PORT not set please provide it:"
    read APPDYNAMICS_CONTROLLER_PORT
  fi
  if [[ -z ${APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY} ]]; then
    echo -e "APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY not set please provide it:"
    read APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY
  fi
}

checkPrerequs
getOptions $@
checkOptions

cd $BASE_DIR
rm -rf spring-music
git clone https://github.com/cloudfoundry-samples/spring-music
cd spring-music

if [[ -z ${REGION} ]] && [[ -z ${KEY} ]]; then
    eb init $APP_NAME -p $PLATFORM
elif [[ -z ${REGION} ]]; then
    eb init $APP_NAME -p $PLATFORM -k $KEY
elif [[ -z ${KEY} ]]; then
    eb init $APP_NAME -p $PLATFORM -r $REGION
else
    eb init $APP_NAME -p $PLATFORM -r $REGION -k $KEY
fi

echo "build: ./gradlew clean assemble" >> Buildfile
echo 'web: java -Dserver.port=8080 -Dspring.profiles.active=in-memory -jar build/libs/staging-1.0.jar' >> Procfile

mkdir .ebextensions
cp -r $BEANSTALK_DIR/_common/.ebextensions/nginx ./.ebextensions
cp $BEANSTALK_DIR/$PLATFORM/.ebextensions/appd.config ./.ebextensions

sed -i.bak "s/APPDYNAMICS_CONTROLLER_HOST_NAME:/APPDYNAMICS_CONTROLLER_HOST_NAME: \"$APPDYNAMICS_CONTROLLER_HOST_NAME\"/" ./.ebextensions/appd.config
sed -i.bak "s/APPDYNAMICS_CONTROLLER_PORT:/APPDYNAMICS_CONTROLLER_PORT: \"$APPDYNAMICS_CONTROLLER_PORT\"/" ./.ebextensions/appd.config
sed -i.bak "s/APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY:/APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY: \"$APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY\"/" ./.ebextensions/appd.config
sed -i.bak "s/APPDYNAMICS_AGENT_APPLICATION_NAME:/APPDYNAMICS_AGENT_APPLICATION_NAME: \"$APP_NAME\"/" ./.ebextensions/appd.config

if [ -n "${APPDYNAMICS_CONTROLLER_SSL_ENABLED:+1}" ]; then
    sed -i.bak "s/#APPDYNAMICS_CONTROLLER_SSL_ENABLED:/APPDYNAMICS_CONTROLLER_SSL_ENABLED: $APPDYNAMICS_CONTROLLER_SSL_ENABLED/" ./.ebextensions/appd.config
fi

find ./ -iname *.bak -exec /bin/bash -c "rm -rf {} " \;
git add ./
git commit -m "eb"

if [[ -z ${INSTANCE} ]]; then
    eb create --timeout 15 $ENV_NAME
else
    eb create --timeout 15 $ENV_NAME -i $INSTANCE
fi

#eb terminate $ENV_NAME --force

exit 0
