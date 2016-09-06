#!/bin/bash

INTERFACE=wlp1s0

P1=`cat /sys/class/net/${INTERFACE}/statistics/rx_bytes`
sleep 1;
P2=`cat /sys/class/net/${INTERFACE}/statistics/rx_bytes`
if [ $(($P2 - $P1)) -lt 2048 ]
 then echo '    --- '
 else echo "$(( $(($P2 - $P1)) / 1))" | awk '{ sum=$1 ; hum[1024**3]="GiB";hum[1024**2]="MiB";hum[1024]="KiB"; for (x=1024**3; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}'
fi
