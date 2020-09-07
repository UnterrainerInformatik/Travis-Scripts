#!/bin/bash

output=$(printf \
    'LOCAL_REPOSITORY=${settings.localRepository}\n'\ 
    'GROUP_ID=${project.groupId}\n'\ 
    'ARTIFACT_ID=${project.artifactId}\n'\ 
    'POM_VERSION=${project.version}\n0\n'|mvn help:evaluate --non-recursive)

export LOCAL_REPO=$(echo "$output" | grep '^LOCAL_REPOSITORY' | cut -d = -f 2)
export GROUP_ID=$(echo "$output" | grep '^GROUP_ID' | cut -d = -f 2)
export ARTIFACT_ID=$(echo "$output" | grep '^ARTIFACT_ID' | cut -d = -f 2)
export POM_VERSION=$(echo "$output" | grep '^POM_VERSION' | cut -d = -f 2)

mvn clean deploy --settings ./$TRAVIS/settings.xml -DskipTests=true -B -U -Prelease
