#!/bin/bash

files=(/home/wallpapers2/*)

active=`readlink ~/.active_wallpaper.jpg`

while [ "$active" = "`readlink ~/.active_wallpaper.jpg`" ]; do
  active=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")
done

ln -sf "$active" ~/.active_wallpaper.jpg
feh --bg-fill "$active"

