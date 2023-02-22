#!/bin/bash

function red(){
    echo -e "\e[31m$1\n"
}

if [ "$SETUPFLAGS" == vnc ]; then
    if ! (apt-get install -y x11vnc xvfb lightdm); then
        red "fail to install vnc"
        exit 255
    fi
    mkdir ~/.vnc
fi
