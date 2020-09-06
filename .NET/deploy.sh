#!/bin/bash

# Since the deploy-stage has limited bash capabilities AND is a different shell,
# we have to re-import everyting.
# Environment variables should be set though (travis takes care of that).
echo "re-sourcing functions"
source travis/functions.NET.sh

echo "starting deploy stage"
if tr_isSetAndNotFalse NUGET; then
    echo "NUGET is set"
    nuget pack ${NUGET_PROJECT_PATH}${NUGET_PROJECT_FILENAME}.csproj -Version $VERSION -Verbosity detailed -Symbols -SymbolPackageFormat snupkg -Prop Configuration=$DEPLOY_BUILD
    nuget push $NUGET_PROJECT_FILENAME.*.nupkg -Verbosity detailed -ApiKey $NUGET_API_KEY -source https://www.nuget.org -SkipDuplicate
else
    echo "skipped deploying nuget since env-variable NUGET is not set or set to [false]."
fi