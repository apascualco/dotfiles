#!/bin/bash
# Sync catppuccin flavor to the current macOS appearance.
# Idempotent and silent (prints nothing): only re-applies the theme when the
# flavor actually changes, so it is cheap to call often.
#
# Invoked two ways from tmux.conf:
#   - periodically, as a #() in status-right (runs every status-interval)
#   - on client-focus-in (instant switch when you refocus the terminal)

CATPPUCCIN="$HOME/.tmux/plugins/tmux/catppuccin.tmux"

# macOS: AppleInterfaceStyle is set to "Dark" only in dark mode; absent in light.
if defaults read -g AppleInterfaceStyle &>/dev/null; then
  want="mocha"   # dark
else
  want="latte"   # light
fi

current="$(tmux show -gv @catppuccin_flavor 2>/dev/null)"

if [ "$want" != "$current" ]; then
  # catppuccin's theme files set the @thm_* palette with `set -og` (only-if-unset),
  # so once a flavor is loaded the palette is "sticky" and re-sourcing alone cannot
  # change it. Clear every @thm_* option first so the new flavor's values apply.
  tmux show -g 2>/dev/null | awk '/^@thm_/{print $1}' | while read -r opt; do
    tmux set -gu "$opt"
  done
  tmux set -g @catppuccin_flavor "$want"
  [ -x "$CATPPUCCIN" ] && "$CATPPUCCIN" >/dev/null 2>&1
fi

exit 0
