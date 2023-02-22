#! /bin/bash

vnc_args=
screen_res=1280x720
color_depth=24

syslogs=/os-env/logs

mkdir "$syslogs"

while ! [ "$1" = -- ] && [ -n "$1" ]; do
    optarg=$(expr "x$1" : 'x[^=]*=\(.*\)')
    case "$1" in
    --vnc-args=*)
        vnc_args=$optarg
    ;;
    --res=*)
        screen_res=$optarg
    ;;
    esac
    shift 1
done

if [ "$1" = -- ]; then
    shift 1
fi

if [ "$FRWD_METHOD" == vnc ]; then
    export DISPLAY=:42  
    Xvfb $DISPLAY -screen 0 "${screen_res}x${color_depth}" | tee "$syslogs/xvfb.log" 2>&1&
    x11vnc -display $DISPLAY -forever -nopw $vnc_args | tee "$syslogs/x11vnc.log" 2>&1&
    startxfce4 | tee "$syslogs/xfce4.log" 2>&1&
fi

if [ $# -eq 0 ]; then
    exec sleep infinity
else
    exec "$@"
fi