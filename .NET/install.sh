#!/bin/bash
nuget restore $SOLUTION_NAME.sln

./scripts/inst_dotnetcoresdk.sh
./scripts/inst_minver.sh