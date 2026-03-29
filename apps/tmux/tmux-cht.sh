#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

languages=$(cat "$SCRIPT_DIR/tmux-cht-languages")
commands=$(cat "$SCRIPT_DIR/tmux-cht-commands")

selected=$(echo "$languages" "$commands" | tr ' ' '\n' | fzf-tmux -p 60%,40% --prompt="cht.sh > " --border --border-label=" cheatsheet ")

if [[ -z $selected ]]; then
    exit 0
fi

read -rp "Query: " query

if echo "$languages" | grep -qs "$selected"; then
    query=$(echo "$query" | tr ' ' '+')
    curl -s "cht.sh/$selected/$query" | less -R
else
    curl -s "cht.sh/$selected~$query" | less -R
fi
