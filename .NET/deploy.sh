#!/bin/bash

if tr_isSetAndNotFalse DEPLOY; then
    nuget pack ${PROJECT_PATH}${PROJECT_FILENAME}.csproj -Version $VERSION -Verbosity detailed -Symbols -SymbolPackageFormat snupkg -Prop Configuration=$DEPLOY_BUILD
    nuget push $PROJECT_FILENAME.*.nupkg -Verbosity detailed -ApiKey $NUGET_API_KEY -source https://www.nuget.org
fi