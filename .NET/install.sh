#!/bin/bash
nuget restore $SOLUTION_NAME.sln

pwd
$(tr_getWorkDir)/.NET/script/inst_netCoresdk.sh
$(tr_getWorkDir)/.NET/script/inst_minver.sh