#!/bin/bash

if tr_isSetAndNotFalse SKIP_BUILD; then
  return 0
fi

npm install
