#!/usr/bin/env bash
export PATH="/run/current-system/sw/bin:$PATH"

# Same as Activity Monitor's "Memory Used": app (anonymous - purgeable) + wired + compressed
percent=$(vm_stat | awk -v total="$(sysctl -n hw.memsize)" '
    /page size of/            { ps = $8 }
    /Anonymous pages/         { anon = $3 }
    /Pages purgeable/         { purg = $3 }
    /Pages wired down/        { wired = $4 }
    /occupied by compressor/  { comp = $5 }
    END { printf "%.0f", (anon - purg + wired + comp) * ps / total * 100 }')

sketchybar --set "$NAME" label="$percent%"
