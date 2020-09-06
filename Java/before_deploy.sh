#!/bin/bash

# Since the deploy-stage has limited bash capabilities AND is a different shell,
# we have to re-import everyting.
# Environment variables should be set though (travis takes care of that).
echo "re-sourcing functions"
source travis/functions.Java.sh

if tr_isSetAndNotFalse RELEASE; then
    mkdir -p ziptemp/$ARTIFACT_ID
    cp -a target/* ziptemp/$ARTIFACT_ID

    cd ziptemp
    zip -r $ARTIFACT_ID.$POM_VERSION.zip $ARTIFACT_ID/*
    mv $ARTIFACT_ID.$POM_VERSION.zip ../$ARTIFACT_ID.$POM_VERSION.zip

    cd -
    rm -rf ziptemp
fi
