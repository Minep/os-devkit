#!/bin/bash

function red(){
    echo -e "\e[31m$1\n"
}

startup_args=()
export_arg=false

while ! [ "$1" = -- ] && [ -n "$1" ]; do
    case "$1" in
        --x11)
            XSOCK=/tmp/.X11-unix
            XAUTH=/tmp/.docker.xauth

            if ! (xauth nlist "$DISPLAY" | sed -e 's/^..../ffff/' | xauth -f "$XAUTH" nmerge -); then
                red 'fail to configure Xauthority.'
                exit 255
            fi

            startup_args+=(-v "$XSOCK:$XSOCK")
            startup_args+=(-v "$XAUTH:$XAUTH")
            startup_args+=(-e "XAUTHORITY=$XAUTH")
            startup_args+=(-e "DISPLAY=$DISPLAY")
        ;;
        --export)
            export_arg=true
        ;;
        *)
            break
        ;;
    esac
    shift 1
done

if [ "$1" = -- ]; then
    shift 1
fi

if [ "$export_arg" = true ]; then
    echo -e "${startup_args[@]}"
    exit 0
fi

sudo docker run ${startup_args[@]} "$@"
