#!/bin/bash

source travis/functions.sh

# make scripts executable
chmod +x travis/.NET/*
chmod +x travis/.NET/scripts/*

# Calculate variables
_SOLUTION="${SOLUTION_NAME}.sln"
if tr_isSet SOLUTION_PATH; then
    echo "solution path is set"
    _SOLUTION="${SOLUTION_PATH}${SOLUTION_NAME}.sln"
fi
echo "command: export SOLUTION_PATH_AND_NAME=$_SOLUTION"
export SOLUTION_PATH_AND_NAME=$_SOLUTION