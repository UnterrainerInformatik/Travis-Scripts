#!/bin/bash
nuget restore $SOLUTION_NAME.sln

$TRAVIS/scripts/inst_dotnetcoresdk.sh
$TRAVIS/scripts/inst_minver.sh
$TRAVIS/scripts/inst_monogame.sh