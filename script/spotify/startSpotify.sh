#!/bin/bash
if ! pidof "spotify" > /dev/null; then
    wmname LG3D;
    spotify &
fi

if ! pidof -x "notificationsSpotify.py" > /dev/null; then
    sleep 1
    exec /home/oskar/script/spotify/notificationsSpotify.py &
fi
