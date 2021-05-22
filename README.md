# wacom-monitor-mapper
Bash script I'm using to quickly change mapping of Wacom drawing tablet to another monitor.

## Requirements
* xrandr
* xsetwacom

## Usage
You can use this scripts with an optional argument.
* No arguments will map you Wacom device to the first monitor the `xrandr` command outputs.
* Number will select the n'th (starting from 0) monitor according to `xrandr` command outputs.
* `-r` will restore default resolution mapping.
