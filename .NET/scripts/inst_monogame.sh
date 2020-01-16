#!/bin/bash

if tr_isSetAndNotFalse MONOGAME; then
    echo "MONOGAME is set to [$MONOGAME]. Installing."
    
    VERSION=$MONOGAME

    if [ "$MONOGAME" = "latest" ]; then
        VERSION=$(curl -s https://api.github.com/repos/MonoGame/MonoGame/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
    fi
    
    echo "MonoGame version is [$VERSION]"
    wget https://github.com/MonoGame/MonoGame/releases/download/$VERSION/monogame-sdk.run
    chmod +x monogame-sdk.run
    sudo ./monogame-sdk.run
fi
