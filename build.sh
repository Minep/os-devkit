#!/bin/bash

function red(){
    echo -e "\e[31m$1\e[0m"
}

function green(){
    echo -e "\e[32m$1\e[0m"
}

function purple () {
    echo -e "\e[35m$1\e[0m"
}

function dobuild() {
    img="$1"
    shift 1
    purple "building: $img"
    if (sudo docker build . -t "$img" "$@"); then
        green "built: $img"
    else
        red "failed: $img"
    fi
}

dobuild lunaixsky/os-devkit:i386-gcc_x11_v1.0 --build-arg frwd_method="x11"
dobuild lunaixsky/os-devkit:i386-gcc_vnc_v1.0 --build-arg frwd_method="vnc"