#!/bin/bash

mvn --settings $TRAVIS/settings.xml install -DskipTests=true -Dgpg.skip -Dmaven.javadoc.skip=true -B -V