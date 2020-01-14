#!/bin/bash

tr_setProjectSubdir() {
    export TRAVIS=travis/$1
    export ROOT=$(pwd)
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
    if tr_isSet ${!1}; then
        if [ "$1" = false]; then
            return 1
        else
            return 0
        fi
    fi
}
