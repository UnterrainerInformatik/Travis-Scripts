#!/bin/bash
echo "command: nuget restore $SOLUTION_PATH_AND_NAME"
nuget restore $SOLUTION_PATH_AND_NAME

source $TRAVIS/scripts/inst_dotnetcoresdk.sh
source $TRAVIS/scripts/inst_minver.sh
source $TRAVIS/scripts/inst_monogame.sh

if tr_isSetAndNotFalse TEST_NUNIT_FILE; then
    nuget install NUnit.Console -Version 3.9.0 -OutputDirectory testrunner
fi

if tr_isSetAndNotFalse TEST_XUNIT_FILE; then
    nuget install xunit.runners -Version 1.9.2 -OutputDirectory testrunner
fi