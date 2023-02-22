#! /bin/bash

export PATH="/os-env/bin:$PATH"

use_vnc=false
vnc_args=

while ! [ "$1" = -- ] && [ -n "$1" ]; do
    optarg=$(expr "x$1" : 'x[^=]*=\(.*\)')
    case "$1" in
    --vnc) 
        use_vnc=true
    ;;
    --vnc-args=*)
        vnc_args=$optarg
    ;;
    esac
    shift 1
done

if [ "$1" = -- ]; then
    shift 1
fi

if [ "$use_vnc" = true ]; then
    x11vnc -forever -create -nopw "$vnc_args" &
fi

exec "$@"