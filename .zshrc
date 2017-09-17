#
# User configuration sourced by interactive shells
#

# Install zim if not already installed
if [[ ! -d ${ZDOTDIR:-${HOME}}/.zim ]]; then
  git clone --recursive https://github.com/Eriner/zim.git ${ZDOTDIR:-${HOME}}/.zim
fi

# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

export EDITOR="vim"
export VISUAL="vim"
export GOPATH=$HOME/go
export PATH=$PATH:$HOME/bin:$GOPATH/bin

# do not share history between terminals
unsetopt share_history
setopt no_share_history

# set emacs keybinding for zsh 
bindkey -e

# make Del key work instead of outputing ~
bindkey    "^[[3~"          delete-char
bindkey    "^[3;5~"         delete-char

alias myip='curl -s http://ip-api.com/json| python -m json.tool'
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

if [ "$TERM" = "xterm" ]; then
    export TERM=xterm-256color
fi
if [ "$TERM" = "screen" -o "$TERM" = "screen-256color" ]; then
    export TERM=screen-256color
    unset TERMCAP
fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
