#!/bin/bash

mvn clean deploy --settings $TRAVIS/settings.xml -DskipTests=true -B -U
