#!/bin/bash

# Since the deploy-stage has limited bash capabilities AND is a different shell,
# we have to re-import everyting.
# Environment variables should be set though (travis takes care of that).
echo "re-sourcing functions"
source travis/functions.npm.sh

rm -rf .deployment-env
touch .deployment-env && echo "#!/usr/bin/env bash" >> .deployment-env
if tr_isSetAndNotFalse DEPLOYMENT_DIRNAME; then
    echo "DEPLOYMENT_DIRNAME=$DEPLOYMENT_DIRNAME" >> .deployment-env
else
    if tr_isSetAndNotFalse REGISTRY_PROJECT; then
        echo "DEPLOYMENT_DIRNAME=$REGISTRY_PROJECT" >> .deployment-env
    fi
fi

if tr_isSetAndNotFalse DOCKER_REGISTRY; then
    npm install

    echo "DEPLOYMENT_USER=$DEPLOYMENT_USER" >> .deployment-env
    echo "DEPLOYMENT_SERVER=$DEPLOYMENT_SERVER" >> .deployment-env
    echo "SSH_PORT=${SSH_PORT:=22}" >> .deployment-env
    echo "REGISTRY_PROJECT=$REGISTRY_PROJECT" >> .deployment-env
    echo "REGISTRY_USER=$REGISTRY_USER" >> .deployment-env
    echo "REGISTRY_PASSWORD=$REGISTRY_PASSWORD" >> .deployment-env
    export HELP_VAR_REG=docker.io
    echo "REGISTRY_URL=${REGISTRY_URL:=$HELP_VAR_REG}" >> .deployment-env
    echo "REGISTRY_URL_AND_GROUP=$REGISTRY_URL_AND_GROUP" >> .deployment-env
    echo "VERSION=$POM_VERSION" >> .deployment-env
    echo "LATEST_VER=$REGISTRY_URL_AND_GROUP/$REGISTRY_PROJECT:latest" >> .deployment-env
    echo "MAJOR_VER=$REGISTRY_URL_AND_GROUP/$REGISTRY_PROJECT:$(echo $POM_VERSION | cut -d. -f1)" >> .deployment-env
    echo "MINOR_VER=$REGISTRY_URL_AND_GROUP/$REGISTRY_PROJECT:$(echo $POM_VERSION | cut -d. -f1).$(echo $POM_VERSION | cut -d. -f2)" >> .deployment-env
    echo "BUILD_VER=$REGISTRY_URL_AND_GROUP/$REGISTRY_PROJECT:$(echo $POM_VERSION | cut -d. -f1).$(echo $POM_VERSION | cut -d. -f2).$(echo $POM_VERSION | cut -d. -f3)" >> .deployment-env
    cat .deployment-env
    if [ -f "set-deployment-env.sh" ]; then
        envsubst < ./set-deployment-env.sh | tee filled-set-deployment-env.sh
        set -a
        source filled-set-deployment-env.sh
        set +a
    fi

    source .deployment-env
    echo "$REGISTRY_PASSWORD"| docker login -u "$REGISTRY_USER" --password-stdin "$REGISTRY_URL"
    docker info
    echo $ "docker build -t $LATEST_VER -t $MAJOR_VER -t $MINOR_VER -t $BUILD_VER ."
    docker build -t $LATEST_VER -t $MAJOR_VER -t $MINOR_VER -t $BUILD_VER .

    echo "docker tag $LATEST_VER $LATEST_VER"
    docker tag $LATEST_VER $LATEST_VER
    echo "docker push $LATEST_VER && docker image rm $LATEST_VER"
    docker push $LATEST_VER && docker image rm $LATEST_VER
    echo "docker tag $MAJOR_VER $MAJOR_VER"
    docker tag $MAJOR_VER $MAJOR_VER
    echo "docker push $MAJOR_VER && docker image rm $MAJOR_VER"
    docker push $MAJOR_VER && docker image rm $MAJOR_VER
    echo "docker tag $MINOR_VER $MINOR_VER"
    docker tag $MINOR_VER $MINOR_VER
    echo "docker push $MINOR_VER && docker image rm $MINOR_VER"
    docker push $MINOR_VER && docker image rm $MINOR_VER
    echo "docker tag $BUILD_VER $BUILD_VER"
    docker tag $BUILD_VER $BUILD_VER
    echo "docker push $BUILD_VER && docker image rm $BUILD_VER"
    docker push $BUILD_VER && docker image rm $BUILD_VER
fi
