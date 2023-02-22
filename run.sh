#!/bin/bash

function red(){
    echo -e "\e[31m$1\n"
}

if [ "$1" == --x11 ]; then
    XSOCK=/tmp/.X11-unix
    XAUTH=/tmp/.docker.xauth

    if ! (xauth nlist "$DISPLAY" | sed -e 's/^..../ffff/' | xauth -f "$XAUTH" nmerge -); then
        red 'fail to configure Xauthority.'
        exit 255
    fi

    shift 1

    sudo docker run -v "$XSOCK:$XSOCK" -v "$XAUTH:$XAUTH" \
                    -e "XAUTHORITY=$XAUTH" -e "DISPLAY=$DISPLAY" "$@"
    exit $?
fi

sudo docker run "$@"
