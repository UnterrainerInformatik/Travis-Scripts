#!/usr/bin/env bash

# This file gets executed once, just before starting the container by calling up.sh, if this file is present at all.

set -a
. ./.env
set +a

#mkdir -p /app/data/overmind-server/mysql-data
