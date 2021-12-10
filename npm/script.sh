#!/bin/bash

if tr_isSetAndNotFalse SKIP_BUILD; then
  exit 0
fi

npm install
