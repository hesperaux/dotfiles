alias dotfiles='/usr/bin/git --git-dir=${HOME}/.dotfiles --work-tree=${HOME}'
alias themefiles='/usr/bin/git --git-dir=${HOME}/.themefiles --work-tree=${HOME}'
alias wallfiles='/usr/bin/git --git-dir=${HOME}/.wallfiles --work-tree=${HOME}'
alias fontfiles='/usr/bin/git --git-dir=${HOME}/.fontfiles --work-tree=${HOME}'
alias looking-glass='/usr/local/bin/looking-glass-client -s -m 97'
alias lal='ls -latr'
alias la='ls -a'
alias wal='/opt/pywal/venv/bin/wal'
alias qtilelog='tail -f ${HOME}/.local/share/qtile/qtile.log'
alias qtile='/opt/qtile/venv/bin/qtile'
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias vim='nvim'
alias l='ls'
alias fontlist='fonts_list'
alias watchping='watch -n 5 "ping -c 1 -W 1 google.com"'
alias nano='nvim'
alias notes='cd ~/Documents/notes/ && nvim'
alias cleanshutdownvms='/root/script/clean_shutdown.sh'
alias cleanrestorevms='/root/script/clean_restore.sh'
alias cleanstartvms='/root/script/clean_restore.sh; /root/script/clean_start.sh'
alias qmk='/opt/qmk/venv/bin/qmk'
alias tmuxa='tmux attach -t '
alias tmuxn='tmux new -s '
alias tmuxkill='tmux kill-session -t '
alias cat='batcat'
alias vncserve='/usr/bin/x0vncserver -display :0 -passwordfile ~/.vnc/passwd -fg'
alias ssh='ssh -X'
# Configuration shortcuts
alias vimconf='cd ~/.config/nvim/ && nvim'
alias nvimconf='cd ~/.config/nvim/ && nvim'
alias zshconf='nvim ~/.zshrc && source ~/.zshrc'
alias bashconf='nvim ~/.bashrc && source ~/.bashrc'
alias aliasconf='nvim ~/.bash_aliases && source ~/.bash_aliases'
alias qtileconf='vim ${HOME}/.config/qtile/config.py'