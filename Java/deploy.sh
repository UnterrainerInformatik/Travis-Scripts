#!/bin/bash

# Since the deploy-stage has limited bash capabilities AND is a different shell,
# we have to re-import everyting.
# Environment variables should be set though (travis takes care of that).
echo "re-sourcing functions"
source travis/functions.Java.sh
source $TRAVIS/before_install.sh

echo "starting deploy stage"

if tr_isSetAndNotFalse MAVEN_CENTRAL; then
  mvn clean deploy --settings $TRAVIS/settings.xml -DskipTests=true -B -U -Prelease
fi

if tr_isSetAndNotFalse DOCKER_REGISTRY; then
  . ./.deployment-env
  cp ./.deployment-env ./deploy/.deployment-env
  cp ./.env ./deploy/.env

  echo "$ DEPLOYMENT_USER=$DEPLOYMENT_USER"
  echo "$ DEPLOYMENT_SERVER=$DEPLOYMENT_SERVER"
  echo "$ SSH_PORT=$SSH_PORT"
  echo "$ REGISTRY_PROJECT=$REGISTRY_PROJECT"
  echo "$ VERSION=$VERSION"

  echo $ ssh -p $SSH_PORT -o StrictHostKeyChecking=no $DEPLOYMENT_USER@$DEPLOYMENT_SERVER "mkdir -p /app/deploy/$REGISTRY_PROJECT && mkdir -p /app/data/$REGISTRY_PROJECT"
  ssh -p $SSH_PORT -o StrictHostKeyChecking=no $DEPLOYMENT_USER@$DEPLOYMENT_SERVER "mkdir -p /app/deploy/$REGISTRY_PROJECT && mkdir -p /app/data/$REGISTRY_PROJECT"
  echo $ chmod 777 ./deploy/*.sh
  chmod 777 ./deploy/*.sh
  echo $ rsync -azh -e 'ssh -p '"$SSH_PORT"'' ./deploy/ $DEPLOYMENT_USER@$DEPLOYMENT_SERVER:/app/deploy/$REGISTRY_PROJECT/
  rsync -azh -e 'ssh -p '"$SSH_PORT"'' ./deploy/ $DEPLOYMENT_USER@$DEPLOYMENT_SERVER:/app/deploy/$REGISTRY_PROJECT/
  echo $ ssh -p $SSH_PORT -o StrictHostKeyChecking=no $DEPLOYMENT_USER@$DEPLOYMENT_SERVER "cd /app/deploy/$REGISTRY_PROJECT && ./up.sh"
  ssh -p $SSH_PORT -o StrictHostKeyChecking=no $DEPLOYMENT_USER@$DEPLOYMENT_SERVER "cd /app/deploy/$REGISTRY_PROJECT && ./up.sh"
fi