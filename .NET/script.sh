#!/bin/bash
export VERSION=$(minver)
echo "Version as determined by minver: $VERSION"

echo "command: msbuild /p:Configuration=$DEPLOY_BUILD /p:VersionNumber=$VERSION $SOLUTION_PATH_AND_NAME"
msbuild /p:Configuration=$DEPLOY_BUILD /p:VersionNumber=$VERSION $SOLUTION_PATH_AND_NAME || return 1

if tr_isSetAndNotFalse TEST_NUNIT_FILE; then
    mono ./testrunner/NUnit.ConsoleRunner.3.9.0/tools/nunit3-console.exe $TEST_NUNIT_FILE || return 1
fi

if tr_isSetAndNotFalse TEST_XUNIT_FILE; then
    mono ./testrunner/xunit.runners.1.9.2/tools/xunit.console.clr4.exe $TEST_XUNIT_FILE || return 1
fi