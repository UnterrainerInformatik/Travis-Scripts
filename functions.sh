#!/bin/bash

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

# make scripts executable
chmod +x travis/*
chmod +x travis/.NET/*
chmod +x travis/.NET/scripts/*

# set environment variable
export TRAVIS=travis/$PROJECT_SUBDIR