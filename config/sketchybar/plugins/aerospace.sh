#!/usr/bin/env bash
export PATH="/run/current-system/sw/bin:/opt/homebrew/bin:$PATH"

sid="$1"
focused=$(aerospace list-workspaces --focused)
apps=$(aerospace list-windows --workspace "$sid" --format '%{app-name}' \
    | sort -u | paste -sd ',' - | sed 's/,/ · /g')

if [ "$sid" = "$focused" ]; then
    sketchybar --set "$NAME" drawing=on background.drawing=on label="$sid  $apps"
elif [ -n "$apps" ]; then
    sketchybar --set "$NAME" drawing=on background.drawing=off label="$sid  $apps"
else
    sketchybar --set "$NAME" drawing=off
fi
