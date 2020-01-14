#!/bin/bash
nuget restore $SOLUTION_NAME.sln

script/inst_netCoresdk.sh
script/inst_minver.sh