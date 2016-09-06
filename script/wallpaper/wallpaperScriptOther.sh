#!/bin/bash
files=(~/.other/*)
#printf "%s\n" "${files[RANDOM % ${#files[@]}]}"
active=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")
feh --bg-fill $active &
