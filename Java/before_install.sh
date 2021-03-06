#!/bin/bash

echo Importing gpg secret key
echo $GPG_SECRET_KEYS | base64 --decode | $GPG_EXECUTABLE --import --no-tty --batch
echo importing gpg ownertrust
echo $GPG_OWNERTRUST | base64 --decode | $GPG_EXECUTABLE --import-ownertrust

# Needed for old version of gnupg. If runner is updated you may remove the next two lines.
echo "allow-loopback-pinentry" >> ~/.gnupg/gpg-agent.conf
gpgconf --reload gpg-agent

echo "Extracting project data from POM"
export LOCAL_REPO=$(mvn -q -Dexec.executable=echo -Dexec.args='${settings.localRepository}' --non-recursive exec:exec)
export GROUP_ID=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.groupId}' --non-recursive exec:exec)
export ARTIFACT_ID=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.artifactId}' --non-recursive exec:exec)
export POM_VERSION_LOCAL=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.version}' --non-recursive exec:exec)
export POM_VERSION=$(git describe --tags)

echo "LOCAL_REPO=${LOCAL_REPO}"
echo "GROUP_ID=${GROUP_ID}"
echo "ARTIFACT_ID=${ARTIFACT_ID}"
echo "POM_VERSION_LOCAL=${POM_VERSION_LOCAL}"
echo "POM_VERSION=${POM_VERSION}"

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
