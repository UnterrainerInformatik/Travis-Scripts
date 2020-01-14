#!/bin/bash
nuget restore $SOLUTION_NAME.sln

$TRAVIS/script/inst_netCoresdk.sh
$TRAVIS/script/inst_minver.sh