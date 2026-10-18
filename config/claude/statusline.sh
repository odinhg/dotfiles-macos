#!/usr/bin/env bash
# Claude Code status line: model | dir | git branch | context used
input=$(cat)
model=$(jq -r '.model.display_name // "claude"' <<<"$input")
dir=$(jq -r '.workspace.current_dir // .cwd // "."' <<<"$input")
branch=$(git -C "$dir" branch --show-current 2>/dev/null)
pct=$(jq -r '.context_window.used_percentage // empty' <<<"$input")

out="$model | ${dir/#"$HOME"/\~}"
[ -n "$branch" ] && out+=" | $branch"
[ -n "$pct" ] && out+=" | ctx ${pct%.*}%"
echo "$out"
