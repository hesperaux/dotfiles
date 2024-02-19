# Setup fzf
# ---------
if [[ ! "$PATH" == */home/hesperaux/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/hesperaux/.fzf/bin"
fi

# Auto-completion
# ---------------
source "/home/hesperaux/.fzf/shell/completion.bash"

# Key bindings
# ------------
source "/home/hesperaux/.fzf/shell/key-bindings.bash"
