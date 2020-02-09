#!/bin/bash

# make scripts executable
chmod +x travis/*
chmod +x travis/.NET/*
chmod +x travis/.NET/scripts/*

tr_setProjectSubdir() {
    export TRAVIS=travis/$1
}

tr_isSet() {
    if [[ -z ${!1+.} ]]; then 
            echo "variable is unset."
            return 1
        else 
            echo "variable is set to [${!1}]."
            return 0
    fi
}

tr_isSetAndNotFalse() {
    if tr_isSet ${1}; then
        if [ "${!1}" = "false" ]; then
            return 1
        else
            return 0
        fi
    else
        return 1
    fi
}

# Calculate variables
_SOLUTION="${SOLUTION_NAME}.sln"
if tr_isSet SOLUTION_PATH; then
    echo "solution path is set"
    _SOLUTION="${SOLUTION_PATH}${SOLUTION_NAME}.sln"
fi
echo "command: export SOLUTION_PATH_AND_NAME=$_SOLUTION"
export SOLUTION_PATH_AND_NAME=$_SOLUTION