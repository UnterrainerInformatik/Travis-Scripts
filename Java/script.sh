#!/bin/bash

output=MVN_VERSION=$(mvn -q \
    -Dexec.executable=echo \
    -Dexec.args='LOCAL_REPOSITORY=${settings.localRepository}\nGROUP_ID=${project.groupId}\nARTIFACT_ID=${project.artifactId}\nPOM_VERSION=${project.version}\n0\n' \
    --non-recursive \
    exec:exec)
    
export LOCAL_REPO=$(echo "$output" | grep '^LOCAL_REPOSITORY' | cut -d = -f 2)
export GROUP_ID=$(echo "$output" | grep '^GROUP_ID' | cut -d = -f 2)
export ARTIFACT_ID=$(echo "$output" | grep '^ARTIFACT_ID' | cut -d = -f 2)
export POM_VERSION=$(echo "$output" | grep '^POM_VERSION' | cut -d = -f 2)

mvn clean deploy --settings $TRAVIS/settings.xml -DskipTests=true -B -U -Prelease
