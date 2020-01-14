#!/bin/bash
nuget restore $SOLUTION_NAME.sln

$ROOT/$TRAVIS/script/inst_netCoresdk.sh
$ROOT/$TRAVIS/.NET/script/inst_minver.sh