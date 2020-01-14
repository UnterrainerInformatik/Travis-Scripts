#!/bin/bash
export VERSION=$(minver)
echo "Version as determined by minver: $VERSION"

msbuild /p:Configuration=Release /p:VersionNumber=$VERSION $SOLUTION_NAME.sln
