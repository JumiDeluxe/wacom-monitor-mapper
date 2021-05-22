#!/bin/bash

help () {
  echo "Usage: $0 [option]"
  echo
  echo "Options:"
  echo "neutral number to select monitor"
  echo "-r to restore your default mapping"
  echo "leave empty to select the first screen"
  echo
  echo "Monitor is choosed depending on position in xrandr listing starting from 0"
}

VALID_ARGUMENT_RE='^[0-9]+$'
DEFAULT_SCREEN_RES=$(xrandr | head -n 1 | sed 's/.*current //' | sed 's/, max.*//' | sed 's/ x /x/')+0+0
RESTORE=false

if [ -z $1 ]
  then
  MONITOR_ID=0
elif [ $1 == "-r" ]
  then
  RESTORE=true  
elif ! [[ $1 =~ $VALID_ARGUMENT_RE ]]
  then
    help
    exit 0
else
  MONITOR_ID=$1
fi

if $RESTORE
  then
  MONITOR_NAME=$DEFAULT_SCREEN_RES
else
  NUMBER_OF_CONNECTED_MONITORS=$(xrandr --listactivemonitors | grep "Monitors:" | cut -d " " -f 2)
  MAX_MONITOR_ID=$((${NUMBER_OF_CONNECTED_MONITORS}-1))

  if [ $MONITOR_ID -gt $MAX_MONITOR_ID ]
    then
    MONITOR_ID=$MAX_MONITOR_ID
  fi
  
  OPENGL_GRAPHICS=$(glxinfo|egrep "OpenGL vendor|OpenGL renderer")

  MONITOR_NAME=$(xrandr --listactivemonitors | grep "$MONITOR_ID:" | tr -s " " | cut -d " " -f 5)

  if [[ "$OPENGL_GRAPHICS" == *"NVIDIA"* ]]; then
    MONITOR_NAME="HEAD-"$MONITOR_ID
  fi
fi

xsetwacom list devices |
while IFS= read -r line; do
  WACOM_DEVICE="$(echo $line)"
  WACOM_DEVICE_ID="$(echo $WACOM_DEVICE | sed 's/.*id: //' | cut -d " " -f 1)"
  xsetwacom --set $WACOM_DEVICE_ID MapToOutput $MONITOR_NAME
  echo "Mapping $WACOM_DEVICE to $MONITOR_NAME..."
done

echo "Finished mapping devices."
