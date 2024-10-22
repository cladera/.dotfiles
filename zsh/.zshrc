[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"

export PATH=$HOME/.config/bin:$PATH
export PATH=$PATH:/opt/homebrew/bin

# Plugins
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "hlissner/zsh-autopair"
plug "zap-zsh/vim"

# Theme
plug "zap-zsh/zap-prompt"

# Completion
plug "zap-zsh/completions"

# Aliases
alias lz="lazygit"
alias lg="lazygit"
alias v="lvim --listen /tmp/nvim-server.pipe"
alias zz='cd $(zoxide query -l | fzf --reverse)'
alias f='cd $(zoxide query -l | fzf --reverse)'

autoload -U +X bashcompinit && bashcompinit

# complete -o nospace -C /usr/local/bin/terraform terraform

# Local 
[ -f "$HOME/.local/.zshrc" ] && source "$HOME/.local/.zshrc"

# NVIM-REMOTE
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    alias nvim=nvr -cc split --remote-wait +'set bufhidden=wipe'
    export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    export GIT_EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
    export VISUAL="lvim"
    export EDITOR="lvim"
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Pyenv
# eval "$(pyenv init -)"

# Zoxide
eval "$(zoxide init zsh)"

# . "$HOME/.asdf/asdf.sh"
. /opt/homebrew/opt/asdf/libexec/asdf.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
