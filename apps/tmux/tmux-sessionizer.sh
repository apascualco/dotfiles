#!/usr/bin/env bash

# Directories to search for projects (depth 1)
SEARCH_DIRS=(
    ~/workdir/acai
    ~/workdir/projects
    ~/workdir/faraday
    ~/workdir/sandbox
    ~/workdir/tools
)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find "${SEARCH_DIRS[@]}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null \
        | fzf-tmux -p 80%,60% \
            --prompt="Project > " \
            --border \
            --border-label=" sessionizer " \
            --preview 'echo "📂 {}" && echo "" && ls -1 --color=always {} 2>/dev/null | head -20 && echo "" && (cd {} && git log --oneline -5 2>/dev/null || echo "no git")')
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s "$selected_name" -c "$selected"
    exit 0
fi

if ! tmux has-session -t="$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"
