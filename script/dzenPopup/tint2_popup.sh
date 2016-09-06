#!/bin/bash

tint2 &
MYPID=$!
sleep 6
kill $MYPID
