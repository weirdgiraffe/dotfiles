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
export PATH=/usr/local/bin:$PATH:$HOME/bin:$GOPATH/bin:$HOME/istio-0.4.0/bin

# do not share history between terminals
unsetopt share_history
setopt no_share_history

# set emacs keybinding for zsh
bindkey -e

# make Del key work instead of outputing ~
bindkey    "^[[3~"          delete-char
bindkey    "^[3;5~"         delete-char

if [ "$TERM" = "xterm" ]; then
    export TERM=xterm-256color
fi
if [ "$TERM" = "screen" -o "$TERM" = "screen-256color" ]; then
    export TERM=screen-256color
    unset TERMCAP
fi

# aliases and other stuff

alias myip='curl -s http://ip-api.com/json| python -m json.tool'
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias go..="cd $GOPATH/src"

function gnu_ls() {
  $(command -v gls || command -v ls) $@
}

alias ls="gnu_ls --color=auto --group-directories-first -F"
alias lah="gnu_ls --color=auto --group-directories-first -Fah"

function kwatchlogs()
{
  while true
  do
    # kubectl logs -f $(kubectl get pods --field-selector=status.phase==Running -l app=$1 -o name)
    kubectl logs -f $(kubectl get po | grep $1 | sed 's/\([^ ]*\).*Running.*$/\1/' | head -1) 2>/dev/null
    echo "reloading..."
  done
}

function plantuml()
{
  cat $1| docker container run --rm -i plantuml -tsvg | cat
}

if [ $commands[cloc] ]; then
  alias cloc="cloc --exclude-dir=.git,vendor"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
fi
