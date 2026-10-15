#!/usr/bin/env bash
export PATH="/run/current-system/sw/bin:$PATH"
export LANG="en_US.UTF-8"

MAX_LEN=15

if ! ipconfig getifaddr en0 >/dev/null 2>&1; then
    sketchybar --set "$NAME" icon="󰖪" icon.color=0x80f2e8cf label.drawing=off
    exit 0
fi

# macOS redacts the SSID unless `sudo ipconfig setverbose 1` has been run once.
ssid=$(ipconfig getsummary en0 | awk -F ' SSID : ' '/ SSID : / {print $2; exit}')
if [ -z "$ssid" ] || [ "$ssid" = "<redacted>" ]; then
    sketchybar --set "$NAME" icon="󰖩" icon.color=0xfff2e8cf label.drawing=off
    exit 0
fi

if [ "${#ssid}" -gt "$MAX_LEN" ]; then
    ssid="${ssid:0:$((MAX_LEN - 1))}…"
fi

sketchybar --set "$NAME" icon="󰖩" icon.color=0xfff2e8cf label.drawing=on label="$ssid"
