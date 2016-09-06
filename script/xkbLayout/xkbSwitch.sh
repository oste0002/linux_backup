#!/bin/bash

xkb=`xkb-switch`

case "$xkb" in
  "se")  xkb-switch -s us
  notify-send "xkbmap: us"
  sudo /opt/script/xkbLayout/led.sh on
  ;;
  "us")  xkb-switch -s se
  notify-send "xkbmap: se"
  sudo /opt/script/xkbLayout/led.sh off
  ;;
esac
