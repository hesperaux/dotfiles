#!/bin/bash
# ============================================================================
# WezTerm SSH Wrapper with Tmux Integration
# ============================================================================
# 
# This script provides smart SSH connections using wezterm's built-in SSH
# client (which properly supports image passthrough) with optional automatic
# tmux session management.
#
# Features:
#   - Auto-detects wezterm SSH capability
#   - Auto-attaches or creates named tmux sessions on remote hosts
#   - Falls back gracefully to regular SSH when not in wezterm
#   - Supports per-host aliases and custom session names
#
# Author: OpenCode Session
# Based on: CONTINUATION_SUMMARY.md (nested tmux image paste fix)
# ============================================================================

# Default tmux session name when auto-starting
DEFAULT_TMUX_SESSION="main"

# Host aliases - maps short names to SSH config hosts
declare -A HOST_ALIASES=(
    ["ood"]="ood"
    ["quasar"]="quasar"
    ["work"]="quasar"
    ["nebula"]="nebula"
    ["ceres"]="ceres"
    ["emonpi"]="emonpi"
    ["emon"]="emonpi"
    ["ai"]="ai"
    ["monolith"]="monolith"
    ["hassio"]="hassio"
    ["orion"]="orion"
    ["aihost"]="aihost"
)

# Load additional host aliases from config file if it exists
if [[ -f "$HOME/.config/wezterm/ssh-hosts.conf" ]]; then
    source "$HOME/.config/wezterm/ssh-hosts.conf"
fi

# Check if we're currently running inside WezTerm
_in_wezterm() {
    [[ -n "$WEZTERM_EXECUTABLE" ]] || [[ -n "$WEZTERM_PANE" ]]
}

# Check if we're already in a WezTerm SSH session
_in_wezterm_ssh() {
    [[ -n "$WEZTERM_REMOTE_PANE" ]]
}

# Get the actual hostname from alias
_resolve_host() {
    local name="$1"
    if [[ -n "${HOST_ALIASES[$name]}" ]]; then
        echo "${HOST_ALIASES[$name]}"
    else
        echo "$name"
    fi
}

# ============================================================================
# CORE FUNCTIONS
# ============================================================================

# Main SSH function - intelligently chooses wezterm ssh or regular ssh
wssh() {
    local host="$1"
    local session_name="${2:-$DEFAULT_TMUX_SESSION}"
    local skip_tmux="${3:-false}"
    
    if [[ -z "$host" ]]; then
        echo "Usage: wssh <host> [session-name] [--no-tmux]"
        echo "       wssh ood"
        echo "       wssh quasar dev-session"
        echo "       wssh ai main --no-tmux"
        echo ""
        echo "Available aliases:"
        for alias in "${!HOST_ALIASES[@]}"; do
            echo "  $alias -> ${HOST_ALIASES[$alias]}"
        done
        return 1
    fi
    
    local actual_host
    actual_host=$(_resolve_host "$host")
    
    if _in_wezterm && ! _in_wezterm_ssh; then
        echo "[wezterm] Connecting to $actual_host..."
        
        if [[ "$skip_tmux" == "true" ]] || [[ "$3" == "--no-tmux" ]]; then
            wezterm ssh "$actual_host"
        else
            wezterm ssh "$actual_host" -- \
                "tmux has-session -t '$session_name' 2>/dev/null && tmux attach -t '$session_name' || tmux new -s '$session_name'"
        fi
    else
        if [[ -n "$SSH_CLIENT" ]]; then
            echo "Warning: Already in SSH session, using regular ssh"
        else
            echo "[ssh] Connecting to $actual_host..."
        fi
        
        if [[ "$skip_tmux" == "true" ]] || [[ "$3" == "--no-tmux" ]]; then
            ssh "$actual_host"
        else
            ssh "$actual_host" -t "tmux has-session -t '$session_name' 2>/dev/null && tmux attach -t '$session_name' || tmux new -s '$session_name'"
        fi
    fi
}

# Raw SSH without tmux
wssh-raw() {
    local host="$1"
    local actual_host
    actual_host=$(_resolve_host "$host")
    
    if _in_wezterm && ! _in_wezterm_ssh; then
        wezterm ssh "$actual_host"
    else
        ssh "$actual_host"
    fi
}

# ============================================================================
# QUICK HOST ALIASES
# ============================================================================

wood() { wssh "ood" "$@"; }
wood-raw() { wssh-raw "ood"; }

wquasar() { wssh "quasar" "$@"; }
wquasar-raw() { wssh-raw "quasar"; }

wwork() { wssh "work" "$@"; }
wwork-raw() { wssh-raw "work"; }

wnebula() { wssh "nebula" "$@"; }
wnebula-raw() { wssh-raw "nebula"; }

wceres() { wssh "ceres" "$@"; }
wceres-raw() { wssh-raw "ceres"; }

wemon() { wssh "emonpi" "$@"; }
wemon-raw() { wssh-raw "emonpi"; }

wai() { wssh "ai" "$@"; }
wai-raw() { wssh-raw "ai"; }

wmonolith() { wssh "monolith" "$@"; }
wmonolith-raw() { wssh-raw "monolith"; }

# ============================================================================
# SESSION MANAGEMENT
# ============================================================================

wls() {
    local host="$1"
    local actual_host
    actual_host=$(_resolve_host "$host")
    
    if _in_wezterm && ! _in_wezterm_ssh; then
        wezterm ssh "$actual_host" -- "tmux list-sessions 2>/dev/null || echo 'No tmux sessions'"
    else
        ssh "$actual_host" "tmux list-sessions 2>/dev/null || echo 'No tmux sessions'"
    fi
}

wkill() {
    local host="$1"
    local session="${2:-$DEFAULT_TMUX_SESSION}"
    local actual_host
    actual_host=$(_resolve_host "$host")
    
    echo "Killing session '$session' on $actual_host..."
    
    if _in_wezterm && ! _in_wezterm_ssh; then
        wezterm ssh "$actual_host" -- "tmux kill-session -t '$session' 2>/dev/null && echo 'Killed' || echo 'Not found'"
    else
        ssh "$actual_host" "tmux kill-session -t '$session' 2>/dev/null && echo 'Killed' || echo 'Not found'"
    fi
}

wnew() {
    local host="$1"
    local session="${2:-$DEFAULT_TMUX_SESSION}"
    local actual_host
    actual_host=$(_resolve_host "$host")
    
    if _in_wezterm && ! _in_wezterm_ssh; then
        wezterm ssh "$actual_host" -- "tmux new -s '$session'"
    else
        ssh -t "$actual_host" "tmux new -s '$session'"
    fi
}

# ============================================================================
# UTILITY COMMANDS
# ============================================================================

wcheck() {
    echo "=== WezTerm SSH Diagnostics ==="
    echo "WEZTERM_EXECUTABLE: ${WEZTERM_EXECUTABLE:-'not set'}"
    echo "WEZTERM_PANE: ${WEZTERM_PANE:-'not set'}"
    echo "WEZTERM_REMOTE_PANE: ${WEZTERM_REMOTE_PANE:-'not set'}"
    echo "SSH_CLIENT: ${SSH_CLIENT:-'not set'}"
    echo ""
    
    if _in_wezterm_ssh; then
        echo "Running inside WezTerm SSH session - images should work!"
    elif _in_wezterm; then
        echo "In WezTerm locally - use 'wssh <host>' for image support"
    else
        echo "Not in WezTerm - images will not work"
    fi
}

whosts() {
    echo "=== Available SSH Host Aliases ==="
    echo ""
    printf "%-15s -> %s\n" "ALIAS" "HOST"
    printf "%s\n" "--------------------------------"
    for alias in $(echo "${!HOST_ALIASES[@]}" | tr ' ' '\n' | sort); do
        printf "%-15s -> %s\n" "$alias" "${HOST_ALIASES[$alias]}"
    done
}

whelp() {
    cat << 'EOF'
=== WezTerm SSH Quick Reference ===

CORE COMMANDS:
  wssh <host> [session]     Connect via wezterm ssh with auto-tmux
  wssh-raw <host>           Connect without tmux

HOST ALIASES:
  wood, wquasar, wnebula, wceres, wemon, wai, wmonolith
  (add -raw suffix for no-tmux, e.g., wood-raw)

SESSION MGMT:
  wls <host>                List remote tmux sessions
  wkill <host> [session]    Kill a remote tmux session  
  wnew <host> [session]     Create new session

INFO:
  wcheck                    Show session status
  whosts                    List configured aliases
  whelp                     Show this help

EXAMPLES:
  wquasar                   # Connect with 'main' tmux session
  wquasar dev               # Connect with 'dev' session
  wquasar-raw               # No tmux
  wls nebula                # List sessions on nebula
  wkill ceres old           # Kill 'old' session on ceres

NOTE: Use wezterm SSH for image paste to work in opencode!
EOF
}

# Generate completion list for zsh
_wssh_complete() {
    local hosts=()
    for alias in "${!HOST_ALIASES[@]}"; do
        hosts+=("$alias")
    done
    echo "${hosts[@]}"
}

# Set up zsh completions if in zsh
if [[ -n "$ZSH_VERSION" ]]; then
    compdef '_values hosts $(_wssh_complete)' wssh wssh-raw wls wkill wnew 2>/dev/null || true
fi

# Main entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-}" in
        check|status) wcheck ;;
        hosts|list) whosts ;;
        help|--help|-h) whelp ;;
        *) [[ -n "${1:-}" ]] && wssh "$@" || whelp ;;
    esac
fi
