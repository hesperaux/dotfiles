#!/bin/bash
shopt -s expand_aliases

. ~/.bash_aliases
DISPLAY=:0 wal -s -t -i ${HOME}/wallpapers/ -n  --saturate 0.5 ; feh --no-fehbg --bg-fill "$(< "${HOME}/.cache/wal/wal")"
/opt/qtile/venv/bin/qtile cmd-obj -o cmd -f reload_config

#for path in $(/opt/nvim-remote/venv/bin/nvr --nostart --serverlist)
#do
#  /opt/nvim-remote/venv/bin/nvr --nostart --servername $path -cc 'Lazy reload pywal.nvim'
#done

