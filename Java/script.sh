#!/bin/bash

echo conditional SKIP_BUILD
if tr_isSetAndNotFalse SKIP_BUILD; then
  return 0
fi

echo Trying to locate the Java JDK...
which Java || whereis java || echo "FATAL: Could not get java-path!"
# export JAVA_HOME=/usr/local/lib/jvm/openjdk11
echo JAVA_HOME: $JAVA_HOME
export PATH="$JAVA_HOME/bin:$PATH"

echo conditional GPG_EXECUTABLE
if tr_isSet GPG_EXECUTABLE; then
  echo $GPG_EXECUTABLE --version
  $GPG_EXECUTABLE --version
fi

echo mvn -B versions:set -DnewVersion=$POM_VERSION -DgenerateBackupPoms=false
mvn -B versions:set -DnewVersion=$POM_VERSION -DgenerateBackupPoms=false

echo conditional MAVEN_CENTRAL
if tr_isSetAndNotFalse MAVEN_CENTRAL; then
  if [ "$TRAVIS_BRANCH" = "master" ]; then
    mvn clean deploy --settings $TRAVIS/settings.xml -B -U -DreleaseSonatype=true
  else
    mvn clean install --settings $TRAVIS/settings.xml -B -U -Prelease
  fi
else
  mvn clean install --settings $TRAVIS/settings.xml -B -U -Prelease
fi
