# Simple WezTerm SSH Aliases
# These are just shortcuts for 'wezterm ssh <host>'

# Quick SSH aliases - just call wezterm ssh directly
# Usage: ssh-ai, ssh-quasar, etc.
alias ssh-ai='wezterm ssh ai'
alias ssh-ood='wezterm ssh ood'
alias ssh-quasar='wezterm ssh quasar'
alias ssh-nebula='wezterm ssh nebula'
alias ssh-ceres='wezterm ssh ceres'
alias ssh-emonpi='wezterm ssh emonpi'
alias ssh-monolith='wezterm ssh monolith'

# With tmux auto-attach (as a function for proper argument handling)
ssh-tmux() {
    local host="$1" session="${2:-main}"
    [[ -z "$host" ]] && { echo "Usage: ssh-tmux <host> [session]"; return 1; }
    wezterm ssh "$host" -- "tmux has-session -t '$session' 2>/dev/null && exec tmux attach -t '$session' || exec tmux new -s '$session'"
}

# Short versions
tmux-ai() { ssh-tmux ai "$@"; }
tmux-quasar() { ssh-tmux quasar "$@"; }
tmux-ood() { ssh-tmux ood "$@"; }

# List remote sessions
ssh-sessions() {
    local host="$1"
    [[ -z "$host" ]] && { echo "Usage: ssh-sessions <host>"; return 1; }
    wezterm ssh "$host" -- "tmux list-sessions 2>/dev/null || echo 'No sessions'"
}

# Quick status check
wezterm-status() {
    echo "WEZTERM: ${WEZTERM_EXECUTABLE:-no}"
    echo "REMOTE:  ${WEZTERM_REMOTE_PANE:-local}"
    [[ -n "$WEZTERM_REMOTE_PANE" ]] && echo "✓ Images work!" || echo "Connect via WezTerm for images"
}

# Help
ssh-help() {
    cat << 'EOF'
=== Quick SSH Aliases ===

Direct SSH (opens in new tab):
  ssh-ai, ssh-ood, ssh-quasar, ssh-nebula, ssh-ceres, ssh-emonpi, ssh-monolith

With tmux:
  ssh-tmux <host> [session]
  tmux-ai [session], tmux-quasar [session], tmux-ood [session]

List sessions:
  ssh-sessions <host>

Status:
  ssh-status

Keybinding:
  Press Ctrl+A then Shift+S in WezTerm for SSH picker

Examples:
  ssh-quasar                    # Just SSH to quasar
  tmux-ai dev                  # SSH to ai with 'dev' tmux session
  ssh-sessions ood             # List tmux sessions on ood
EOF
}

# Pic Sync - Copy uploaded screenshot to current directory
# Run this in opencode with: !picsync
picsync() {
    if [[ -f ~/pic.png ]]; then
        cp ~/pic.png ./pic.png
        echo "✅ pic.png copied to current directory"
        echo "   Use @pic.png in opencode"
    else
        echo "❌ ~/pic.png not found"
        echo "   Upload a screenshot first from your local terminal:"
        echo "   pic-ai  # or pic-quasar, etc."
        return 1
    fi
}

# Completions
if [[ -n "$ZSH_VERSION" ]] && type compdef &>/dev/null; then
    _ssh_hosts() { local -a h=(ai ood quasar nebula ceres emonpi monolith); _describe 'hosts' h; }
    _ssh_sess() { local -a s=(main dev code ssh adm); _describe 'sessions' s; }
    compdef _ssh_hosts ssh-tmux ssh-sessions
    _ssh_tmux_args() { _arguments '1:host:_ssh_hosts' '2:session:_ssh_sess'; }
    compdef _ssh_tmux_args ssh-tmux
fi
