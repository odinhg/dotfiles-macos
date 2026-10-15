#!/usr/bin/env bash
export PATH="/run/current-system/sw/bin:$PATH"

info=$(pmset -g batt)
percent=$(printf '%s' "$info" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
[ -z "$percent" ] && exit 0

if printf '%s' "$info" | grep -q "AC Power"; then
    icon="󰂄"
elif [ "$percent" -ge 90 ]; then icon="󰁹"
elif [ "$percent" -ge 70 ]; then icon="󰂀"
elif [ "$percent" -ge 50 ]; then icon="󰁾"
elif [ "$percent" -ge 30 ]; then icon="󰁼"
elif [ "$percent" -ge 10 ]; then icon="󰁺"
else icon="󰂎"
fi

sketchybar --set "$NAME" icon="$icon" label="$percent%"
