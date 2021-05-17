#!/bin/bash

if [ -z "$1" ]
  then
  MONITOR_ID=0
elif [ "$1" == "--help" ]
  then
    echo "Usage: $0 [monitor]"
    echo
    echo "Monitor is choosed depending on position in xrandr listing starting from 0"
  exit 0
else
  MONITOR_ID=$1

  NUMBER_OF_CONNECTED_MONITORS=$(xrandr --listactivemonitors | grep "Monitors:" | cut -d " " -f 2)
  MAX_MONITOR_ID=${NUMBER_OF_CONNECTED_MONITORS+1}

  if [ $MONITOR_ID -gt $MAX_MONITOR_ID ]
    then
    MONITOR_ID=$MAX_MONITOR_ID
  elif [ $MONITOR_ID -lt 0 ]
    then
    MONITOR_ID=0
  fi
  
fi

MONITOR_NAME=$(xrandr --listactivemonitors | grep "$MONITOR_ID:" | tr -s " " | cut -d " " -f 5)

xsetwacom list devices |
while IFS= read -r line; do
  WACOM_DEVICE="$(echo $line)"
  WACOM_DEVICE_ID="$(echo $WACOM_DEVICE | sed 's/.*id: //' | cut -d " " -f 1)"
  xsetwacom --set $WACOM_DEVICE_ID MapToOutput $MONITOR_NAME
  echo "Mapped $WACOM_DEVICE to $MONITOR_NAME"
done

echo "Finished mapping devices."
