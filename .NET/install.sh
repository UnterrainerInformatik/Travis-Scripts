#!/bin/bash
nuget restore $SOLUTION_NAME.sln

source $TRAVIS/scripts/inst_dotnetcoresdk.sh
source $TRAVIS/scripts/inst_minver.sh
source $TRAVIS/scripts/inst_monogame.sh