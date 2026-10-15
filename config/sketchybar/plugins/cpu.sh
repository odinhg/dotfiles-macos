#!/usr/bin/env bash
export PATH="/run/current-system/sw/bin:$PATH"

# The first top sample is since boot, so take two and use the second.
# Line looks like: "CPU usage: 3.5% user, 5.2% sys, 91.2% idle"
usage=$(top -l 2 -n 0 -s 1 | awk '/CPU usage/ {idle = $7} END {if (idle != "") printf "%.0f", 100 - idle}')
[ -z "$usage" ] && exit 0

sketchybar --set "$NAME" label="$usage%"
