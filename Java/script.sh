#!/bin/bash

mvn -B versions:set -DnewVersion=$POM_VERSION -DgenerateBackupPoms=false
if tr_isSetAndNotFalse MAVEN_CENTRAL; then
  if [ "$TRAVIS_BRANCH" = "master" ]; then
    mvn clean deploy --settings $TRAVIS/settings.xml -B -U -DreleaseSonatype=true
  else
    mvn clean install --settings $TRAVIS/settings.xml -B -U -Prelease
  fi
else
  mvn clean install --settings $TRAVIS/settings.xml -B -U -Prelease
fi

