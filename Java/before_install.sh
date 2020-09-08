#!/bin/bash

echo Importing gpg secret key
echo $GPG_SECRET_KEYS | base64 --decode | $GPG_EXECUTABLE --import
echo importing gpg ownertrust
echo $GPG_OWNERTRUST | base64 --decode | $GPG_EXECUTABLE --import-ownertrust
