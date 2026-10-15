#!/usr/bin/env bash
export PATH="/run/current-system/sw/bin:$PATH"

# volume_change passes the new volume in $INFO; otherwise ask the system.
if [ "$SENDER" = "volume_change" ]; then
    volume="$INFO"
else
    volume=$(osascript -e 'output volume of (get volume settings)')
fi
muted=$(osascript -e 'output muted of (get volume settings)')

if [ "$muted" = "true" ] || [ "$volume" = "0" ]; then
    icon="󰖁"
elif [ "$volume" -ge 60 ]; then icon="󰕾"
elif [ "$volume" -ge 30 ]; then icon="󰖀"
else icon="󰕿"
fi

sketchybar --set "$NAME" icon="$icon" label="$volume%"
