#!/bin/bash

#instances_running=$[ $[ `pidof -x xbacklight-inc.sh | wc -w` ] + $[ `pidof -x xbacklight-dec.sh | wc -w` ]]
#echo $instances_running

current_light=`xbacklight -get`
int=${current_light/.*}

if [ $int -le 2 ]; then
  exit 0 
elif [ $int -le 4 ]; then
  int=$[ $int - 1 ]
elif [ $int -le 11 ]; then
  int=$[ $int - 5 ]
else
  int=$[ $int - 9 ]
fi


case $int in
[0-4])
  message="[|                    ]"
  ;;
[4-9])
  message="[ |                   ]"
  ;;
1[0-4])
  message="[  |                  ]"
  ;;
1[4-9])
  message="[   |                 ]"
  ;;
2[0-4])
  message="[    |                ]"
  ;;
2[4-9])
  message="[     |               ]"
  ;;
3[0-4])
  message="[      |              ]"
  ;;
3[4-9])
  message="[       |             ]"
  ;;
4[0-4])
  message="[        |            ]"
  ;;
4[4-9])
  message="[         |           ]"
  ;;
5[0-4])
  message="[          |          ]"
  ;;
5[4-9])
  message="[           |         ]"
  ;;
6[0-4])
  message="[            |        ]"
  ;;
6[4-9])
  message="[             |       ]"
  ;;
7[0-4])
  message="[              |      ]"
  ;;
7[4-9])
  message="[               |     ]"
  ;;
8[0-4])
  message="[                |    ]"
  ;;
8[4-9])
  message="[                 |   ]"
  ;;
9[0-4])
  message="[                  |  ]"
  ;;
9[4-9])
  message="[                    |]"
  ;;
100)
  message="[                    |]"
esac

notify-send "brightness: $message"
#gdbus call --session --dest org.freedesktop.Notifications --object-path /org/freedesktop/Notifications --method org.freedesktop.Notifications.Notify fn-key 42 "" "brightness: $message" ""  [] {} 3000


current_light=`xbacklight -get`
int=${current_light/.*}

if [ $int -le 11 ]; then
  if [ $int -le 4 ]; then
    if [ $int -le 2 ]; then
     exit 0 
    fi
    xbacklight -dec 1
  else
    xbacklight -dec 5
  fi
else
  xbacklight -dec 10
fi

current_light=`xbacklight -get`
int=${current_light/.*}

if [ $int -lt 2 ]; then
  xbacklight -set 2
fi

