#!/bin/bash

mvn clean install --settings $TRAVIS/settings.xml -B -U
