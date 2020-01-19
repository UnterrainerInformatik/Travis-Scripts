#!/bin/bash

mkdir -p ziptemp/$SOLUTION_NAME
cp -a $BUILD_TARGET/* ziptemp/$SOLUTION_NAME

cd ziptemp
zip -r $DEPLOY_BUILD.$VERSION.zip $SOLUTION_NAME/*
mv $DEPLOY_BUILD.$VERSION.zip ../$DEPLOY_BUILD.$VERSION.zip

cd -
rm -rf ziptemp