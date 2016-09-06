#!/bin/bash

volume=`amixer get Master|tail -n1|sed -E 's/.*\[([0-9]+)\%\].*/\1/'`
muted=`amixer get Master|tail -n1|sed -E 's/.*\[([a-z]+)\]/\1/'`

if [ $muted == "on" ]; then
  if [ $volume -lt 25 ]; then
    amixer -D pulse set Master 5%-
  else
    amixer -D pulse set Master 10%-
  fi
fi

volume=`amixer get Master|tail -n1|sed -E 's/.*\[([0-9]+)\%\].*/\1/'`

hex=$(( $volume*655 ))
hex=0x`echo "ibase=10; obase=16; $hex" | bc`
pactl "set-sink-volume" "alsa_output.pci-0000_00_03.0.hdmi-stereo-extra1" $hex

if [ $muted == "off" ]; then
  message="muted"
else
  case $volume in
  [0-4])
    message="    [|                    ]"
    ;;
  [5-9])
    message="    [ |                   ]"
    ;;
  1[0-4])
    message="    [  |                  ]"
    ;;
  1[5-9])
    message="    [   |                 ]"
    ;;
  2[0-4])
    message="    [    |                ]"
    ;;
  2[5-9])
    message="    [     |               ]"
    ;;
  3[0-4])
    message="    [      |              ]"
    ;;
  3[5-9])
    message="    [       |             ]"
    ;;
  4[0-4])
    message="    [        |            ]"
    ;;
  4[5-9])
    message="    [         |           ]"
    ;;
  5[0-4])
    message="    [          |          ]"
    ;;
  5[5-9])
    message="    [           |         ]"
    ;;
  6[0-4])
    message="    [            |        ]"
    ;;
  6[5-9])
    message="    [             |       ]"
    ;;
  7[0-4])
    message="    [              |      ]"
    ;;
  7[5-9])
    message="    [               |     ]"
    ;;
  8[0-4])
    message="    [                |    ]"
    ;;
  8[5-9])
    message="    [                 |   ]"
    ;;
  9[0-4])
    message="    [                  |  ]"
    ;;
  9[5-9])
    message="    [                   | ]"
    ;;
  100)
    message="    [                    |]"
    ;;
  esac
fi

notify-send "volume: $message"
gdbus call --session --dest org.freedesktop.Notifications --object-path /org/freedesktop/Notifications --method org.freedesktop.Notifications.Notify volume-dec 42 audio-card "volume: $message" "" [] {} 3000
