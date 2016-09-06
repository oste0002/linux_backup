#!/bin/bash

DIR="/home/oskar/script/dzenPopup"

exec $DIR/tint2_popup.sh &
exec $DIR/network_popup.sh &
exec $DIR/time_popup.sh &
exec $DIR/system_popup.sh

