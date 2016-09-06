#!/bin/bash

if xrandr | grep "HDMI1 connected" > /dev/null; then
  xrandr --output HDMI1 --left-of eDP1
fi
