#!/bin/bash

# make scripts executable
chmod +x travis/*
echo "checking for set_deployment_env.sh"
if [ -f "set_deployment_env.sh" ]; then
    echo "set_deployment_env.sh found, setting permissions..."
    chmod +x set_deployment_env.sh
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
