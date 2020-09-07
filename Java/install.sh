#!/bin/bash

mvn --settings .settings.xml install -DskipTests=true -Dgpg.skip -Dmaven.javadoc.skip=true -B -V