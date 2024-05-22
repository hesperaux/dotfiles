
source ~/.zgen/zgenom.zsh

# if the init script doesn't exist
if ! zgenom saved; then
plugins=(
    web-search
    terraform
    ripgrep
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-syntax-highlighting
    zsh-users/zsh-completions
    zsh-users/zsh-history-substring-search
    zsh-users/zsh-navigation-tools
)
  # specify plugins here
  zgenom ohmyzsh
  # generate the init script from plugins above
  zgenom save
fi

