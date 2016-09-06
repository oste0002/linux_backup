#!/bin/bash

notify-send "Disabling screensaver"
xset -dpms; xset s off

google-chrome-stable --enable-overlay-scrollbar --start-fullscreen www.netflix.com

notify-send "Enabling screensaver"
xset +dpms; xset s on
