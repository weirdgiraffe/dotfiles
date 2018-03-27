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

# ----------------------------------------------------
# deduplicate history entries
setopt hist_save_no_dups
# do not save lines starting with space in history
setopt hist_ignore_space
# do share history between terminals
unsetopt inc_append_history
unsetopt inc_append_history_time
setopt share_history

# set emacs keybinding for zsh
bindkey -e

# make Del key work instead of outputing ~
bindkey    "^[[3~"          delete-char
bindkey    "^[3;5~"         delete-char

# set up/down key as well as CTRL+P/CTRL+N to work with
# a local history only but CTRL+R will still work with
# a global history
function up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}
zle -N up-line-or-local-history
function down-line-or-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}
zle -N down-line-or-local-history
bindkey '^[OA' up-line-or-local-history
bindkey '^[OB' down-line-or-local-history
bindkey '^P' up-line-or-local-history
bindkey '^N' down-line-or-local-history
# ----------------------------------------------------

# prevent terminal suspend on CTRL+S
stty -ixon

if [ "$TERM" = "xterm" ]; then
    export TERM=xterm-256color
fi
if [ "$TERM" = "screen" -o "$TERM" = "screen-256color" ]; then
    export TERM=screen-256color
    unset TERMCAP
fi

export GOPATH=$HOME/go
export PATH=/usr/local/bin:$PATH:$HOME/bin:$GOPATH/bin:$HOME/istio-0.5.0/bin

# aliases and other stuff
alias myip='curl -s http://ip-api.com/json| python -m json.tool'
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias go..="cd $GOPATH/src"

function gnu_ls() {
  cmd=$(command -v gls)
  [ -z "$cmd" ] && cmd=$(command -p -v ls)
  $cmd $@
}

function vim() {
  $(command -v nvim || command -v vim) $@
}

alias ls="gnu_ls --color=auto --group-directories-first -F"
alias lah="gnu_ls --color=auto --group-directories-first --time-style long-iso -Flah"

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

if [ -f ~/.fzf.zsh ]; then
  [ $commands[fd] ] && export FZF_ALT_C_COMMAND="command fd -L -t d -t l"
  source ~/.fzf.zsh
fi

if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
fi

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

export EDITOR="vim"
export VISUAL="vim"
if [ $commands[nvim] ]; then
  export EDITOR="nvim"
  export VISUAL="nvim"
fi

autoload -U colors; colors
source /usr/local/etc/zsh-kubectl-prompt/kubectl.zsh
RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'
