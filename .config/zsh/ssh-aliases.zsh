# Simple WezTerm SSH Aliases - just type these in your shell

# Basic SSH (opens in new window, images work)
alias ssh-ai='wezterm ssh ai'
alias ssh-ood='wezterm ssh ood'
alias ssh-quasar='wezterm ssh quasar'
alias ssh-nebula='wezterm ssh nebula'
alias ssh-ceres='wezterm ssh ceres'
alias ssh-emonpi='wezterm ssh emonpi'
alias ssh-monolith='wezterm ssh monolith'

# SSH with tmux auto-attach
alias ssh-ai-tmux='wezterm ssh ai -- "tmux has-session -t main 2>/dev/null && exec tmux attach -t main || exec tmux new -s main"'
alias ssh-quasar-tmux='wezterm ssh quasar -- "tmux has-session -t main 2>/dev/null && exec tmux attach -t main || exec tmux new -s main"'

# Quick status check
alias ssh-status='echo "WEZTERM_REMOTE_PANE: ${WEZTERM_REMOTE_PANE:-local}"'

# Help
ssh-help() {
    cat << 'EOF'
=== WezTerm SSH Aliases ===

Just type these in your shell:
  ssh-ai, ssh-ood, ssh-quasar, ssh-nebula, ssh-ceres, ssh-emonpi, ssh-monolith

With tmux auto-attach:
  ssh-ai-tmux, ssh-quasar-tmux

Check if images work:
  ssh-status  (should show a number, not "local")

That's it! The aliases just run "wezterm ssh <host>" which properly
supports image passthrough (OSC 1337 protocol).

Once connected, try pasting an image - it should work!
EOF
}
