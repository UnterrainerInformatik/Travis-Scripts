#!/bin/bash

# Since the deploy-stage has limited bash capabilities AND is a different shell,
# we have to re-import everyting.
# Environment variables should be set though (travis takes care of that).
echo "re-sourcing functions"
source travis/functions.npm.sh
source $TRAVIS/before_install.sh

echo "starting deploy stage"

if tr_isSetAndNotFalse DEPLOY; then
  rm -rf .env
  cp ./.deployment-env ./.env
  if [ -f "./set-deployment-env.sh" ]; then
    envsubst < ./set-deployment-env.sh | tee ./filled-set-deployment-env.sh
    cat ./filled-set-deployment-env.sh >> ./.env
  fi
  if [ -f "./deploy/config.js" ]; then
    envsubst < ./deploy/config.js | tee ./filled-config.js
    cp ./filled-config.js ./deploy/config.js
  fi
  set -a
  . ./.env
  set +a
  cp ./.env ./deploy/.env

  if [ -f "./deploy/pre-deploy.sh" ]; then
    envsubst < ./deploy/pre-deploy.sh | tee ./filled-pre-deploy.sh
    cp ./filled-pre-deploy.sh ./deploy/pre-deploy.sh
  fi
  
  echo "$ DEPLOYMENT_USER=$DEPLOYMENT_USER"
  echo "$ DEPLOYMENT_SERVER=$DEPLOYMENT_SERVER"
  echo "$ SSH_PORT=$SSH_PORT"
  echo "$ REGISTRY_PROJECT=$REGISTRY_PROJECT"
  echo "$ DEPLOYMENT_DIRNAME=$DEPLOYMENT_DIRNAME"
  echo "$ VERSION=$VERSION"

  echo $ ssh -p $SSH_PORT -o StrictHostKeyChecking=no $DEPLOYMENT_USER@$DEPLOYMENT_SERVER "mkdir -p /app/deploy/$DEPLOYMENT_DIRNAME && mkdir -p /app/data/$DEPLOYMENT_DIRNAME"
  ssh -p $SSH_PORT -o StrictHostKeyChecking=no $DEPLOYMENT_USER@$DEPLOYMENT_SERVER "mkdir -p /app/deploy/$DEPLOYMENT_DIRNAME && mkdir -p /app/data/$DEPLOYMENT_DIRNAME"
  echo $ chmod 777 ./deploy/*.sh
  chmod 777 ./deploy/*.sh
  
  echo $ rsync -azh -e 'ssh -p '"$SSH_PORT"'' ./deploy/ $DEPLOYMENT_USER@$DEPLOYMENT_SERVER:/app/deploy/$DEPLOYMENT_DIRNAME/
  rsync -azh -e 'ssh -p '"$SSH_PORT"'' ./deploy/ $DEPLOYMENT_USER@$DEPLOYMENT_SERVER:/app/deploy/$DEPLOYMENT_DIRNAME/
  
  if [ -f "./deploy/pre-deploy.sh" ]; then
    echo $ ssh -p $SSH_PORT -o StrictHostKeyChecking=no $DEPLOYMENT_USER@$DEPLOYMENT_SERVER "cd /app/deploy/$DEPLOYMENT_DIRNAME && ./pre-deploy.sh"
    ssh -p $SSH_PORT -o StrictHostKeyChecking=no $DEPLOYMENT_USER@$DEPLOYMENT_SERVER "cd /app/deploy/$DEPLOYMENT_DIRNAME && ./pre-deploy.sh"
  fi
  
  echo $ ssh -p $SSH_PORT -o StrictHostKeyChecking=no $DEPLOYMENT_USER@$DEPLOYMENT_SERVER "cd /app/deploy/$DEPLOYMENT_DIRNAME && ./up.sh"
  ssh -p $SSH_PORT -o StrictHostKeyChecking=no $DEPLOYMENT_USER@$DEPLOYMENT_SERVER "cd /app/deploy/$DEPLOYMENT_DIRNAME && ./up.sh"
fi
