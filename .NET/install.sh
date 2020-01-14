#!/bin/bash
nuget restore $SOLUTION_NAME.sln

$(tr_getWorkDir)/script/inst_netCoresdk.sh
$(tr_getWorkDir)/script/inst_minver.sh