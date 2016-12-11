#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

xsetroot -cursor_name left_ptr &
xset r rate 450 30 &
# xset m 3/2 0 &
xset m 4/3 0 &

if ! [xrandr | grep "HDMI1 connected" > /dev/null]; then
  xrandr --output HDMI1 --right-of eDP1 --primary &
fi

xbacklight -set 50 &
# setxkbmap -layout se,us -option caps:escape &
setxkbmap -layout se,us -option caps:escape &
trayer --edge top --align left --margin 1824 --SetDockType true --SetPartialStrut false --expand true --widthtype pixel --width 96 --transparent true --alpha 30 --tint 0x000000 --height 18 &
insync start &
xfce4-power-manager &
nm-applet &
systemctl --user start dzenify.service &
#exec openbox
EDITOR=vim
mkdir /tmp/oskar

exec $1
# exec xmonad
# exec openbox-session
