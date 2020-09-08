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
