# WezTerm Shell Integration for Zsh
# Source this from .zshrc:
#   [[ -f ~/.config/wezterm/wezterm-aliases.zsh ]] && source ~/.config/wezterm/wezterm-aliases.zsh

# Source the SSH wrapper
[[ -f "$HOME/.config/wezterm/wezterm-ssh.sh" ]] && source "$HOME/.config/wezterm/wezterm-ssh.sh"

# WezTerm-aware aliases
alias ssh-wezterm='wezterm ssh'
alias wnew-win='wezterm cli spawn --new-window'
alias wnew-tab='wezterm cli spawn'
alias wsplit-right='wezterm cli split-pane --right'
alias wsplit-bottom='wezterm cli split-pane --bottom'

# Tmux aliases
alias ta='tmux attach'
alias tn='tmux new-session -s'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'

# Smart tmux attach
t() {
    local session="${1:-main}"
    if tmux has-session -t "$session" 2>/dev/null; then
        tmux attach -t "$session"
    else
        tmux new-session -s "$session"
    fi
}

# Workspace helpers
workspace-code() {
    local session="${1:-code}"
    if ! tmux has-session -t "$session" 2>/dev/null; then
        tmux new-session -d -s "$session" -n rust
        tmux new-window -t "$session" -n term-1
        tmux new-window -t "$session" -n term-2
        tmux new-window -t "$session" -n term-3
        tmux select-window -t "$session":1
    fi
    tmux attach -t "$session"
}

workspace-ssh() {
    local session="${1:-ssh}"
    if ! tmux has-session -t "$session" 2>/dev/null; then
        tmux new-session -d -s "$session" -n local
    fi
    tmux attach -t "$session"
}

workspace-adm() {
    local session="${1:-adm}"
    if ! tmux has-session -t "$session" 2>/dev/null; then
        tmux new-session -d -s "$session" -n admin
        tmux new-window -t "$session" -n shell
        tmux select-window -t "$session":1
    fi
    tmux attach -t "$session"
}

workspace() {
    case "$1" in
        code|dev) workspace-code "${2:-code}" ;;
        ssh|remote) workspace-ssh "${2:-ssh}" ;;
        adm|admin) workspace-adm "${2:-adm}" ;;
        *) echo "Usage: workspace <code|ssh|adm> [session]" ;;
    esac
}

# Image diagnostic
diagnose-images() {
    echo "=== Image Paste Diagnostic ==="
    echo ""
    echo "Terminal: $WEZTERM_EXECUTABLE"
    echo "WEZTERM_REMOTE_PANE: ${WEZTERM_REMOTE_PANE:-'not in wezterm ssh'}"
    echo "SSH_CLIENT: ${SSH_CLIENT:-'not in ssh'}"
    echo "TMUX: ${TMUX:-'not in tmux'}"
    echo ""
    if [[ -n "$WEZTERM_REMOTE_PANE" ]]; then
        echo "✅ WezTerm SSH session - images will work!"
    elif [[ -n "$WEZTERM_EXECUTABLE" && -z "$SSH_CLIENT" ]]; then
        echo "⚠️  Local WezTerm - use 'wssh <host>' for remote images"
    elif [[ -n "$SSH_CLIENT" ]]; then
        echo "❌ Regular SSH - images won't work. Use 'wssh <host>' from WezTerm"
    fi
}
