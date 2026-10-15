#!/usr/bin/env bash
export PATH="/run/current-system/sw/bin:/opt/homebrew/bin:$PATH"

# Updates every space.N item in one pass (run by the hidden "spaces" item).
# FOCUSED_WORKSPACE is set when triggered from exec-on-workspace-change.
focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"
windows=$(aerospace list-windows --all --format '%{workspace}|%{app-name}')

args=()
for sid in 1 2 3 4 5; do
    apps=$(printf '%s\n' "$windows" | awk -F'|' -v s="$sid" '$1 == s { print $2 }' \
        | sort -u | paste -sd ',' - | sed 's/,/ · /g')

    if [ "$sid" = "$focused" ]; then
        args+=(--set "space.$sid" drawing=on background.drawing=on label="$sid  $apps")
    elif [ -n "$apps" ]; then
        args+=(--set "space.$sid" drawing=on background.drawing=off label="$sid  $apps")
    else
        args+=(--set "space.$sid" drawing=off)
    fi
done

sketchybar "${args[@]}"
