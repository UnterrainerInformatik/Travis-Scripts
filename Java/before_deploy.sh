#!/bin/bash

# Since the deploy-stage has limited bash capabilities AND is a different shell,
# we have to re-import everyting.
# Environment variables should be set though (travis takes care of that).
echo "re-sourcing functions"
source travis/functions.Java.sh

if tr_isSetAndNotFalse RELEASE; then
    echo "RELEASE is set -> making ZIP-file"
    mkdir -p ziptemp/$ARTIFACT_ID
    cp -a target/* ziptemp/$ARTIFACT_ID

    cd ziptemp
    zip -r $ARTIFACT_ID.$POM_VERSION.zip $ARTIFACT_ID/*
    mv $ARTIFACT_ID.$POM_VERSION.zip ../$ARTIFACT_ID.$POM_VERSION.zip

    cd -
    rm -rf ziptemp
    echo "done making ZIP-file"
fi

if tr_isSetAndNotFalse DOCKER_REGISTRY; then
    echo "DOCKER_REGISTRY is set -> starting to prepare docker-deployment-phase"
    cp target/$REGISTRY_PROJECT-$POM_VERSION.jar target/application.jar && rm -rf .deployment-env
    touch .deployment-env && echo "#!/usr/bin/env bash" >> .deployment-env
    echo "DEPLOYMENT_USER=$DEPLOYMENT_USER" >> .deployment-env
    echo "DEPLOYMENT_SERVER=$DEPLOYMENT_SERVER" >> .deployment-env
    echo "SSH_PORT=${SSH_PORT:=22}" >> .deployment-env
    echo "ARTIFACT_ID=$ARTIFACT_ID" >> .deployment-env
    echo "GROUP_ID=$GROUP_ID" >> .deployment-env
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
        set -a
        source set-deployment-env.sh
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
    echo "done preparing docker-deployment-phase"
fi
