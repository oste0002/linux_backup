#!/bin/bash
status=`insync get_status`
case $status in
SYNCED)
  if [ `insync pause_syncing` = "OK" ]; then
    message="Paused"
  else
    message="Error"
  fi
  ;;
PAUSED)
  if [ `insync resume_syncing` = "OK" ]; then
    message="Syncing"
  else
    message="Error"
  fi
 ;;
OFFLINE)
 if [ `insync start` = "OK" ]; then
   message="Started"
 else
   message="Error"
 fi
 ;;
*)
  message=$status
  ;;
esac

notify-send "Google Drive: $message"
