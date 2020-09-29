#!/bin/bash

if tr_isSetAndNotFalse MAVEN_CENTRAL; then
  mvn clean deploy --settings $TRAVIS/settings.xml -B -U -DreleaseSonatype=true
else
  mvn clean install --settings $TRAVIS/settings.xml -B -U -Prelease
fi


