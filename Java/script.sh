#!/bin/bash

echo "Extracting project data from POM"
export LOCAL_REPO=$(mvn -q -Dexec.executable=echo -Dexec.args='${settings.localRepository}' --non-recursive exec:exec)
export GROUP_ID=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.groupId}' --non-recursive exec:exec)
export ARTIFACT_ID=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.artifactId}' --non-recursive exec:exec)
export POM_VERSION=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.version}' --non-recursive exec:exec)

echo "LOCAL_REPO=${LOCAL_REPO}"
echo "GROUP_ID=${GROUP_ID}"
echo "ARTIFACT_ID=${ARTIFACT_ID}"
echo "POM_VERSION=${POM_VERSION}"

mvn clean deploy --settings $TRAVIS/settings.xml -DskipTests=true -B -U -Prelease
