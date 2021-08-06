#
# User configuration sourced by interactive shells
#

# Install zim if not already installed
if [[ ! -d ${ZDOTDIR:-${HOME}}/.zim ]]; then
  local ZIM_DIR=${ZDOTDIR:-${HOME}}/.zim
  local SPACESHIP_DIR=${ZIM_DIR}/modules/prompt/external-themes/spaceship
  git clone https://github.com/zimfw/zimfw.git ${ZIM_DIR}
  (
  cd ${ZIM_DIR};
  git config --file=.gitmodules submodule.modules/prompt/external-themes/pure.url https://github.com/weirdgiraffe/pure.git;
  git config --file=.gitmodules submodule.modules/prompt/external-themes/pure.branch master;
  git submodule sync;
  git submodule update --init --recursive --remote;
  )
fi

if [[ "$(uname)" = "Darwin" ]]; then
  # if homebrew is already being installed
  _BREW_PREFIX=$(brew --prefix)
  [[ -f ${_BREW_PREFIX}/bin/rg ]] || brew install rg
  [[ -f ${_BREW_PREFIX}/bin/python3 ]] || brew install python3
  [[ -f ${_BREW_PREFIX}/bin/go ]] || brew install go
  [[ -f ${_BREW_PREFIX}/bin/jq ]] || brew install jq
  [[ -f ${_BREW_PREFIX}/bin/http ]] || brew install httpie

  [[ -d ${_BREW_PREFIX}/Cellar/coreutils ]] || brew install coreutils
  [[ -d ${_BREW_PREFIX}/Cellar/tmux ]] || brew install tmux
  [[ -d ${_BREW_PREFIX}/Cellar/neovim ]] || brew install neovim
  [[ -d ${_BREW_PREFIX}/Cellar/kubernetes-cli ]] || brew install kubectl
  [[ -d ${_BREW_PREFIX}/Cellar/fzf ]] || ( brew install fzf && $(brew --prefix)/opt/fzf/install )
  [[ -d ${_BREW_PREFIX}/Cellar/fd ]] || brew install fd
  [[ -d ${_BREW_PREFIX}/Cellar/node ]] || brew install node
  [[ -d ${_BREW_PREFIX}/Cellar/yarn ]] || brew install yarn
  [[ -d ${_BREW_PREFIX}/Cellar/reattach-to-user-namespace ]] || brew install reattach-to-usernamespace
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

# a local history only but CTRL+R will still work with
# a global history
function up-line-or-search-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}
zle -N up-line-or-search-local-history

function down-line-or-search-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}
zle -N down-line-or-search-local-history

#bindkey '\eOA' up-line-or-search-local-history
#bindkey '\eOB' down-line-or-search-local-history
bindkey '^[[A' up-line-or-search-local-history
bindkey '^[[B' down-line-or-search-local-history
bindkey '^P' up-line-or-search-local-history
bindkey '^N' down-line-or-search-local-history
# ----------------------------------------------------

# prevent terminal suspend on CTRL+S
stty -ixon

if [ "$TERM" = "tmux" -o "$TERM" = "tmux-256color" ]; then
    export TERM=tmux-256color
fi

if [ "$TERM" = "xterm" -o "$TERM" = "xterm-256color" ]; then
    export TERM=xterm-256color
fi

if [ "$TERM" = "screen" -o "$TERM" = "screen-256color" ]; then
    export TERM=screen-256color
fi

export GOPATH=$HOME/go

path+=("$HOME/bin" "$GOPATH/bin" "$HOME/google-cloud-sdk/bin")
typeset -U path
export PATH

export GREP_COLOR="01;31"


# aliases and other stuff
alias myip='curl -s http://ip-api.com/json| python -m json.tool'
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias urldecode='python -c "import sys, urllib as ul; \
    print ul.unquote_plus(sys.argv[1])"'

alias urlencode='python -c "import sys, urllib as ul; \
    print ul.quote_plus(sys.argv[1])"'

function gnu_ls() {
  cmd=$(command -v gls)
  [ -z "$cmd" ] && cmd=$(command -p -v ls)
  $cmd $@
}

function vim() {
  $(command -v nvim || command -v vim) $@
}

alias vi=vim
alias dc="docker compose"
alias k="kubectl"
alias kgn="kubectl --namespace=glassnode"
alias kjn="kubectl --namespace=jobs"
alias kbn="kubectl --namespace=blockchain"
alias kdn="kubectl --namespace=database"

alias ls="gnu_ls --color=auto --group-directories-first -F"
alias ll="gnu_ls --color=auto --group-directories-first --time-style=long-iso -Fl"
alias la="gnu_ls --color=auto --group-directories-first --time-style=long-iso -Fla"
alias lah="gnu_ls --color=auto --group-directories-first --time-style=long-iso -Flah"

function plantuml()
{
  docker container run --rm -i -v $(pwd):$(pwd) -w $(pwd) plantuml -tsvg $1
}

function wscat() 
{
  docker container run --rm -it wscat wscat $@
}

alias trello='docker run --rm -it 3llo'

if [ $commands[cloc] ]; then
  alias cloc="cloc --exclude-dir=.git,vendor"
fi

# source ~/bin/gruvbox_256palette_osx.sh

if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
  if [ $commands[fd] ]; then
    export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude '{.git,.svn,.ropeproject,__pycache__,vendor,node_modules}'"
    export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude '{.git,.svn,.ropeproject,__pycache__,vendor,node_modules}'"
    export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
    _fzf_compgen_dir() {
      fd --type d --hidden --follow --exclude '{.git,.svn,.ropeproject,__pycache__,vendor,node_modules}'
    }
    _fzf_compgen_path() {
      fd --type f --hidden --follow --exclude '{.git,.svn,.ropeproject,__pycache__,vendor,node_modules}'
    }
  fi
fi

if [ -d /usr/local/share/zsh/site-functions ]; then
  export FPATH=/usr/local/share/zsh/site-functions:${FPATH}
fi

if [ -d $HOME/google-cloud-sdk/bin ]; then
  alias gcloud-kubectl="$HOME/google-cloud-sdk/bin/kubectl"
fi

if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
fi

if [ $commands[helm] ]; then
  source <(helm completion zsh)
fi

# disable until 2.14
# if [ $commands[helm] ]; then
#   source <(helm completion zsh)
# fi

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

export EDITOR="vim"
export VISUAL="vim"
if [ $commands[nvim] ]; then
  export EDITOR="nvim"
  export VISUAL="nvim"
fi


if [ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ]; then 
  source "${HOME}/google-cloud-sdk/completion.zsh.inc"
fi

#
# cd aliases
#
alias rfcdate='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias unixdate='date +"%s"'
function unixdatetorfc() {
	date -r $1 -u +"%Y-%m-%dT%H:%M:%SZ"
}

gocd() { cd ${GOPATH}/src/$1 }
compctl -/ -W ${GOPATH}/src/ gocd

datazoo() { cd ${HOME}/projects/datazoo/$1 }
compctl -/ -W ${HOME}/projects/datazoo/ datazoo

projects() { cd ~/projects/$1 }
compctl -/ -W ~/projects projects






alias remove-obsolete-branches="git fetch -p && git branch -vv| sed '/: gone] /!d;s/^[ ]*\([^ ]*\) .*$/\1/' | xargs git branch -D"

alias failedjobs="kubectl -n jobs get jobs -o json| jq -r '.items[]| select (.status.conditions[0].type == \"Failed\")|\"\(.status.startTime)\t\(.metadata.name)\"'|sort -n"
alias runningjobs="kubectl -n jobs get jobs -o json| jq -r '.items[]| select (.status.active > 0)|\"\(.status.startTime)\t\(.metadata.name)\"'|sort -n"

alias alljobs="kubectl -n jobs get jobs -o json | \
	jq -r '.items[]|\"\(.status.startTime)\t\(.metadata.name)\t\(.status.completionTime)\t\(.status.conditions[0].type)\"'|sort -n"


function mdserve() {
	mkdir -p ./rendered
	find ./ -iname "*.md" -type f -exec sh -c 'pandoc "${0}" -f gfm -t html --self-contained -o "rendered/${0%.md}"' {} \;
	devd ./rendered
}


function dumpjob() {
  kubectl -n jobs describe job $1
  glogs $1
}

function preexec() {
    cmd_timer=${cmd_timer:-$SECONDS}
}

function print_seconds {
  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  (( $D > 0 )) && printf '%d d ' $D
  (( $H > 0 )) && printf '%d h ' $H
  (( $M > 0 )) && printf '%d m ' $M
  (( $D > 0 || $H > 0 || $M > 0 )) && printf ' '
  printf '%d s' $S
}

function precmd() {
  if [ $cmd_timer ]; then
    RPROMPT=${RPROMPT%% %F{white}*\[* s\]%f}
    if (( $SECONDS - $cmd_timer > 0 )); then
          elapsed=$(($SECONDS - $cmd_timer))
          display_elapsed=$(print_seconds ${elapsed})
          RPROMPT=${RPROMPT}" %F{white}[${display_elapsed}]%f"
    fi
    unset cmd_timer
  fi
}

# remove rprompt of previous commands
setopt transient_rprompt

bindkey -s "^v" "vim **\t"

export CLOUDSDK_PYTHON=python3.9
export GOPRIVATE=github.com/weirdgiraffe,gitlab.com/glassnode
alias tf='terraform'


_git_repo_root() {
  git rev-parse --show-toplevel 2>/dev/null
}

rr() { 
  local _CURRENT_REPO_ROOT=$(_git_repo_root)
  if [[ -n ${_CURRENT_REPO_ROOT} ]] 
  then
    cd ${_CURRENT_REPO_ROOT}/$1
  fi
}

_fzf_complete_rr() {
  local _CURRENT_REPO_ROOT=$(_git_repo_root)
  if [[ -n ${_CURRENT_REPO_ROOT} ]]
  then
    _fzf_complete --reverse --prompt="repo:cd> " -- "$@" < <(
	cd ${_CURRENT_REPO_ROOT} && fd -td
    )
  fi
}

github() { 
  cd ${GOPATH}/src/github.com/$1
}

_fzf_complete_github() {
  _fzf_complete --preview 'ls -1 ${GOPATH}/src/github.com/{}' --reverse --prompt="github> " -- "$@" < <(
    cd ${GOPATH}/src/github.com/
    fd -I -H '^\.git$' | sed 's#/\.git$##'
  )
}

gitlab() { 
  cd ${GOPATH}/src/gitlab.com/$1
}

_fzf_complete_gitlab() {
  _fzf_complete --preview 'ls -1 ${GOPATH}/src/gitlab.com/{}' --reverse --prompt="gitlab> " -- "$@" < <(
    cd ${GOPATH}/src/gitlab.com/
    fd -I -H '^\.git$' | sed 's#/\.git$##'
  )
}


fzf-no-prefix-completion() {
  setopt localoptions noshwordsplit noksh_arrays noposixbuiltins
  local tokens cmd no_trigger
  tokens=(${(z)LBUFFER})
  cmd=${tokens[1]}
  no_trigger=(rr github gitlab)
  if [[ -n "${no_trigger[(r)${cmd}]}" ]]; then
    FZF_COMPLETION_TRIGGER="" fzf-completion
  else
    fzf-completion
  fi
}

zle -N fzf-no-prefix-completion
bindkey '^I' fzf-no-prefix-completion
