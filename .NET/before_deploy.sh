#!/bin/bash

# Since the deploy-stage has limited bash capabilities AND is a different shell,
# we have to re-import everyting.
# Environment variables should be set though (travis takes care of that).
echo "re-sourcing functions"
source travis/functions.sh

mkdir -p ziptemp/$SOLUTION_NAME
cp -a $BUILD_TARGET/* ziptemp/$SOLUTION_NAME

cd ziptemp
zip -r $DEPLOY_BUILD.$VERSION.zip $SOLUTION_NAME/*
mv $DEPLOY_BUILD.$VERSION.zip ../$DEPLOY_BUILD.$VERSION.zip

cd -
rm -rf ziptemp