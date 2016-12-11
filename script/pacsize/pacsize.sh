#!/bin/bash
pacman -Qi | egrep '^(Name|Installed)' | cut -f2 -d':' | tr '\nK' ' \n' | sort -nrk 2
