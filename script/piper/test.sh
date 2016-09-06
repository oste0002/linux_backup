#!/bin/bash

UPTIME=`cat /proc/uptime | cut -d' ' --complement -f2-`
sleep 1
UPTIME2=`cat /proc/uptime | cut -d' ' --complement -f2-`
echo `echo "$UPTIME2 - $UPTIME" | bc -l`
