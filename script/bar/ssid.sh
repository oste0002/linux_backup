#!/bin/bash
iw dev wlp1s0 link | grep SSID | sed "s/^.*SSID:\s//g"
