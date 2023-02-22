#!/bin/bash

function red(){
    echo -e "\e[31m$1\n"
}

if [ "$FRWD_METHOD" == vnc ]; then
    if ! (apt-get install -y x11vnc xvfb xfce4); then
        red "fail to install vnc"
        exit 255
    fi

    mkdir "${HOME}/.vnc"
fi
