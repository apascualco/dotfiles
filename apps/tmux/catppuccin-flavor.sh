#!/bin/bash
# Returns catppuccin flavor based on macOS appearance
if defaults read -g AppleInterfaceStyle &>/dev/null; then
  echo "mocha"
else
  echo "latte"
fi
