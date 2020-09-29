#!/bin/bash

if tr_isSetAndNotFalse DEPLOY; then
    echo "DEPLOY is set -> starting to prepare SSH-deployment-phase"
    echo "DEPLOY is set -> importing SSH keys"
    echo "openssl aes-256-cbc -K ${!DEPLOYMENT_SSH_KEY_VARNAME} -iv ${!DEPLOYMENT_SSH_IV_VARNAME} -in $SSH_ENC_FILE_NAME_WO_EXT.enc -out /tmp/$SSH_ENC_FILE_NAME_WO_EXT -d"
    openssl aes-256-cbc -K ${!DEPLOYMENT_SSH_KEY_VARNAME} -iv ${!DEPLOYMENT_SSH_IV_VARNAME} -in $SSH_ENC_FILE_NAME_WO_EXT.enc -out /tmp/$SSH_ENC_FILE_NAME_WO_EXT -d

    echo "configuring SSH agent"
    eval "$(ssh-agent -s)"
    echo "chmod 600 /tmp/$SSH_ENC_FILE_NAME_WO_EXT"
    chmod 600 /tmp/$SSH_ENC_FILE_NAME_WO_EXT
    echo "ssh-add /tmp/$SSH_ENC_FILE_NAME_WO_EXT"
    ssh-add /tmp/$SSH_ENC_FILE_NAME_WO_EXT
    echo "done preparing SSH-deployment-phase"
fi
