#!/usr/bin/env bash

theme="$HOME/.config/rofi/style.rasi"

## Run
this_network=$(netctl list| grep '*' | sed 's/\*//gi')
network=$(netctl list | sed 's/\*//gi' | rofi \
    -show -dmenu \
    -theme ${theme})

if [ $this_network -seq '' ]; then
  sudo netctl start ${network}
else
  sudo netctl stop ${this_network}
  sudo netctl start ${network}
fi
