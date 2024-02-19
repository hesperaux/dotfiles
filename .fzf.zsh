# Setup fzf
# ---------
if [[ ! "$PATH" == */home/hesperaux/git/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/hesperaux/git/fzf/bin"
fi

# Auto-completion
# ---------------
source "/home/hesperaux/git/fzf/shell/completion.zsh"

# Key bindings
# ------------
source "/home/hesperaux/git/fzf/shell/key-bindings.zsh"
