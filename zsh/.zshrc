[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"

export PATH=$HOME/.config/bin:$PATH

# Plugins
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "hlissner/zsh-autopair"
plug "zap-zsh/vim"
plug "zap-zsh/completions"

# Theme
plug "zap-zsh/zap-prompt"

# Completion
plug "esc/conda-zsh-completion"

# Aliases
alias tn='tmux new -s $(pwd | sed "s/.*\///g")'
alias ts='tmux list'
alias lz="lazygit"
alias v="lvim"
alias zz='cd $(zoxide query -l | fzf --reverse)'

autoload -U +X bashcompinit && bashcompinit

complete -o nospace -C /usr/local/bin/terraform terraform

# Local 
[ -f "$HOME/.local/.zshrc" ] && source "$HOME/.local/.zshrc"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Pyenv
eval "$(pyenv init -)"

# Zoxide
eval "$(zoxide init zsh)"

