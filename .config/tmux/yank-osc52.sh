#!/bin/bash
# OSC 52 clipboard copy script for tmux
# This works through SSH without X11 forwarding
# Supports nested tmux sessions

# Read input from stdin
buf=$(cat)

# Get the length of the buffer
buflen=$(printf %s "$buf" | wc -c)

# Maximum length for OSC 52 (100000 bytes is safe for most terminals)
maxlen=100000

# Check if the buffer is too large
if [ "$buflen" -gt "$maxlen" ]; then
  echo "Selection too large to send to terminal (${buflen} bytes, max ${maxlen})" >&2
  exit 1
fi

# Base64 encode the buffer
buf64=$(printf %s "$buf" | base64 | tr -d '\r\n')

# Detect if we're in a tmux session
if [ -n "$TMUX" ]; then
  # We're in tmux, use tmux's passthrough mechanism
  # The DCS sequence wraps the OSC 52 to pass through tmux to the terminal
  # This works even in nested tmux sessions
  printf '\ePtmux;\e\e]52;c;%s\a\e\\' "$buf64"
else
  # We're not in tmux, send OSC 52 directly
  printf '\e]52;c;%s\a' "$buf64"
fi
