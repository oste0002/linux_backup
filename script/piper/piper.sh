#!/bin/bash

tempfile="/home/oskar/tmp/piper"
read -r uptime _ < /proc/uptime

if [ -e $tempfile ]; then 
  echo "$uptime $1" >> $tempfile
else
  touch $tempfile
  tail -n1 -f $tempfile | stdbuf -i0 -o0 cut -d ' ' -f 2- | dzen2 -p '6' -x 735 -y 0 -w 390 -l 0 -sa 'c' -ta 'c' -bg '#222222' -h '16' -fn terminus -fg '#EEEEEE' -e 'onstart=uncollapse;button1=exit;button3=exit' &
  #tail -f $tempfile | cut -d' ' -f2- | dzen2 -p '6' -x 735 -y 0 -w 390 -l 0 -sa 'c' -ta 'c' -bg '#222222' -h '16' -fn terminus -fg '#EEEEEE' -e 'onstart=uncollapse;button1=exit;button3=exit' &
  pipe_pid=$!
  sleep 0.1
  echo "$uptime $1" >> $tempfile
  sleep 4

  while true; do
    uptime= cut -d ' ' -f 1 /proc/uptime
    echo $uptime
    active_uptime= cut -d ' ' -f 1 $TEMPFILE
    if (( active_uptime - uptime > 1 )); then
      sleep 1
    else
      break
    fi
  done

  rm $tempfile
  kill $pipe_pid
fi

