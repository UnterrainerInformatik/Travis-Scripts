#!/bin/bash

npm install
if [ -f "set_deployment_env.sh" ]; then
    rm -rf .env
    touch .env
    source set_deployment_env.sh
fi
