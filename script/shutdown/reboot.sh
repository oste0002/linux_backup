#!/bin/bash

list=`wmctrl -l | grep VIM`
while read -r line; do
  if echo $line | grep + >/dev/null ; then 
    read WIN WS <<< `echo $line  | cut -d ' ' -f 1,2`
  fi  
done <<< "$list"

if ! [ -z "$WIN" ]; then
  notify-send "Workspace $((WS + 1))"
  wmctrl -ia $WIN
else
  for i in {1..5}
  do
    if pidof -x "chromium" >/dev/null; then
      wmctrl -c chromium
      sleep 0.5
    else
      systemctl --no-ask-password reboot
      sleep 2
    fi
  done
fi
