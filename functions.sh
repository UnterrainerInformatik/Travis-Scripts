#!/bin/bash

# make scripts executable
chmod +x travis/*
chmod +x travis/.NET/*
chmod +x travis/.NET/scripts/*

# check for configured builds and cancel others
if [ "$TR_TYPE" = "core" ] && [ -z "$BUILD_CORE" ]; then
    echo "Skipping build 'core' as not configured"
    exit
fi
if [ "$TR_TYPE" = "mono" ] && [ -z "$BUILD_MONO" ]; then
    echo "Skipping build 'mono' as not configured"
    exit
fi

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
