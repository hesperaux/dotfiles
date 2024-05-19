bindkey -v
[[ -f $HOME/.bash_aliases ]] && source ~/.bash_aliases
[[ -f $HOME/.bash_priv_aliases ]] && source ~/.bash_priv_aliases
[[ -f $HOME/.shell_functions.sh ]] && source ~/.shell_functions.sh

export ZSH=$HOME/.config/zsh
[[ -f $ZSH/history.zsh ]] && source $ZSH/history.zsh
[[ -f $ZSH/plugins.zsh ]] && source $ZSH/plugins.zsh
[[ -f $ZSH/zoxide.zsh ]] && source $ZSH/zoxide.zsh

export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export PATH=${PATH}:/usr/local/:${HOME}/go/bin/:${HOME}/.local/bin/codelldb/extension/adapter/:${HOME}/.cargo/bin/
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${HOME}/git/cuda/cuda-11.8/lib64
export CUDA_HOME=${HOME}/git/cuda/cuda-11.8/
export EDITOR=nvim
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="
	--color=fg:#908caa,bg:#191724,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:#191724
	--color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
[[ -d $PYENV_ROOT/bin ]] && eval "$(pyenv init -)"

