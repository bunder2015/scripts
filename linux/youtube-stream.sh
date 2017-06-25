#!/bin/bash

if [ -n "$1" ] ; then
        youtube-dl -o - $1 | vlc -
else
        echo "need a url to stream"
        exit 1
fi

