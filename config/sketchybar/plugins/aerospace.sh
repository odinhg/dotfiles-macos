#!/usr/bin/env bash
export PATH="/etc/profiles/per-user/odinhg/bin:$PATH"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on
else
    sketchybar --set $NAME background.drawing=off
fi
