#!/bin/bash

if tr_isSetAndNotFalse SKIP_BUILD; then
  return 0
fi

echo Trying to locate the Java JDK...
which Java ||whereis java || echo "FATAL: Could not get java-path!"
export JAVA_HOME=/usr/local/lib/jvm/openjdk11
echo JAVA_HOME: $JAVA_HOME
export PATH="$JAVA_HOME/bin:$PATH"

echo Importing gpg secret key
echo $GPG_SECRET_KEYS | base64 --decode | $GPG_EXECUTABLE --import --no-tty --batch
echo importing gpg ownertrust
echo $GPG_OWNERTRUST | base64 --decode | $GPG_EXECUTABLE --import-ownertrust

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
