() { #anonymous function to scope variables

  local LOCAL_FUNCTIONS_DIR="${ZDOTDIR:-${HOME}}/.config/zsh/functions"
  local CACHE_COMPLETIONS_DIR="${ZDOTDIR:-${HOME}}/.cache/zsh/completions"
  local CACHE_FUNCTIONS_DIR="${ZDOTDIR:-${HOME}}/.cache/zsh/functions"
  local ZCOMPDUMP_FILE="${ZDOTDIR:-${HOME}}/.cache/zsh/zcompdump"
  local ZHISTORY_FILE="${ZDOTDIR:-${HOME}}/.cache/zsh/zhistory"

  mkdir -p ${CACHE_COMPLETIONS_DIR}
  mkdir -p ${CACHE_FUNCTIONS_DIR}
  mkdir -p ${ZCOMPDUMP_FILE:a:h}
  mkdir -p ${ZHISTORY_FILE:a:h}

  # workaround for the cluttered environment
  typeset -U upath
  for i ($path) { upath+=($i) }
  upath=(
    "$(brew --prefix)/opt/coreutils/libexec/gnubin"
    "${HOME}/.cargo/bin"
    "$(go env GOPATH)/bin"
    "${HOME}/bin"
    ${upath}
  )
  path=(${upath})

  # set defaults shell keybindings to emacs keybindings
  bindkey -e

  EDITOR="nvim"
  VISUAL="nvim"

  # use red color for grep matches to match rg
  GREP_COLORS="mt=01;31"

  # needed to allow to work with GPG
  # reference: https://gist.github.com/troyfontaine/18c9146295168ee9ca2b30c00bd1b41e
  GPG_TTY=$(tty)

  # golang specific settings
  GOPRIVATE=github.com/weirdgiraffe

  # ------------------------------------------------------------------------------
  # ------------------------------------------------------------------------------

  # history setup
  # reference: man zshoptions

  # where to keep the history file
  HISTFILE=${ZHISTORY_FILE}
  # how many last lines of history to save in memory (kind of unlimited)
  HISTSIZE=1000000
  # how many last lines of history to save to the HISTFILE (last 1000 lines)
  SAVEHIST=1000

  # shared history
  setopt SHARE_HISTORY
  setopt EXTENDED_HISTORY
  unsetopt INC_APPEND_HISTORY
  unsetopt INC_APPEND_HISTORY_TIME

  # dups
  setopt HIST_IGNORE_DUPS
  setopt HIST_IGNORE_ALL_DUPS
  setopt HIST_EXPIRE_DUPS_FIRST
  setopt HIST_FIND_NO_DUPS
  setopt HIST_SAVE_NO_DUPS

  # misc
  setopt HIST_IGNORE_SPACE
  setopt HIST_VERIFY
  setopt HIST_REDUCE_BLANKS

  # add keybindings to searth the history, i.e. when I'm on the line like ls
  # those keypresses will search history with this prefix and suggest things
  # like ls /tmp, ls /var, etc.
  bindkey '^[[A' history-search-backward
  bindkey '^]]B' history-search-forward

  # ------------------------------------------------------------------------------
  # ------------------------------------------------------------------------------
  # misc functions
  zcompare() {
    if [[ -s ${1} && ( ! -s ${1}.zwc || ${1} -nt ${1}.zwc ) ]]; then
      zcompile -R ${1}
    fi
  }

  zcompare_and_source() { zcompare ${1} && source ${1} }

  # ------------------------------------------------------------------------------
  # ------------------------------------------------------------------------------
  # completions

  # NOTE: assume that brew is already installed
  [[ -s ${CACHE_COMPLETIONS_DIR}/_pyenv ]]  || cp $(brew --prefix pyenv)/completions/pyenv.zsh ${CACHE_COMPLETIONS_DIR}/_pyenv
  [[ -s ${CACHE_COMPLETIONS_DIR}/_docker ]] || docker completion zsh > ${CACHE_COMPLETIONS_DIR}/_docker

  # NOTE: assume that rustup is already installed
  [[ -s ${CACHE_COMPLETIONS_DIR}/_rustup ]] || rustup completions zsh > ${CACHE_COMPLETIONS_DIR}/_rustup
  [[ -s ${CACHE_COMPLETIONS_DIR}/_cargo ]]  || rustup completions zsh cargo > ${CACHE_COMPLETIONS_DIR}/_cargo
   
  fpath=(
    $(brew --prefix)/share/zsh-completions/
    ${CACHE_COMPLETION_DIR}
    $fpath
  )

  autoload -Uz compinit
  if [[ -n ${ZCOMPDUMP_FILE} ]]; then
    compinit -i -C -d "${ZCOMPDUMP_FILE}"
  else
    compinit -i -d "${ZCOMPDUMP_FILE}"
  fi
  zcompare ${ZCOMPDUMP_FILE}

  # If a completion is performed with the cursor within a word, and a full
  # completion is inserted, the cursor is moved to the end of the word.
  setopt ALWAYS_TO_END
  # Perform a path search even on command names with slashes in them.
  setopt PATH_DIRS
  # Make globbing (filename generation) not sensitive to case.
  setopt NO_CASE_GLOB
  # Don't beep on an ambiguous completion.
  setopt NO_LIST_BEEP

  # group matches and describe.
  zstyle ':completion:*:*:*:*:*' menu select
  zstyle ':completion:*:matches' group yes
  zstyle ':completion:*:options' description yes
  zstyle ':completion:*:options' auto-description '%d'
  zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'
  zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
  zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
  zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
  zstyle ':completion:*' format '%F{yellow}-- %d --%f'
  zstyle ':completion:*' group-name ''
  zstyle ':completion:*' verbose yes
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' '+r:|?=**'

  # ------------------------------------------------------------------------------
  # ------------------------------------------------------------------------------
  # plugins

  # oh-my-posh: (need to comment out if want to benchmark)
  if [[ ! -s ${CACHE_FUNCTIONS_DIR}/oh-my-posh.zsh ]]; then
   oh-my-posh init zsh --config=${HOME}/.config/oh-my-posh/config.toml > ${CACHE_FUNCTIONS_DIR}/oh-my-posh.zsh
  fi

  # NOTE: pyenv has an extremely slow initialization function
  #       so it is reimplemented as ${CACHE_FUNCTIONS_DIR}/pyenv.zsh
  #
  # NOTE: peynv doesn't rehash on start, so need to run pyenv rehash manually
  if [[ ! -s ${CACHE_FUNCTIONS_DIR}/pyenv-virtualenv.zsh ]]; then
    pyenv virtualenv-init -  >> ${CACHE_FUNCTIONS_DIR}/pyenv-virtualenv.zsh
  fi

  if [[ ! -s ${CACHE_FUNCTIONS_DIR}/zoxide.zsh ]]; then
    zoxide init zsh > ${CACHE_FUNCTIONS_DIR}/zoxide.zsh
  fi

  # precompile and source all autogenerated functions
  for file in ${CACHE_FUNCTIONS_DIR}/*.zsh; do
    zcompare_and_source ${file}
  done
  # precompile and source all my custom functions
  for file in ${LOCAL_FUNCTIONS_DIR}/*.zsh; do
    zcompare_and_source ${file}
  done

  zcompare_and_source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  # syntax-highlight should be the last plugin
  zcompare_and_source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  # ------------------------------------------------------------------------------
  # ------------------------------------------------------------------------------

  alias ls="ls --color --group-directories-first -F"
  alias l="ls --color --group-directories-first -Fl"
  alias ll="ls --color --group-directories-first --time-style=long-iso -Fl"
  alias la="ls --color --group-directories-first --time-style=long-iso -Fla"
  alias lah="ls --color --group-directories-first --time-style=long-iso -Flah"
  alias grep="grep --color=auto"
  alias v="nvim"
  alias vi="nvim"
  alias vim="nvim"
  alias tf='terraform'
  alias k='kubectl'
  alias rg='rg --ignore-file=${HOME}/.config/fd/ignore'
  alias myip='curl -s http://ip-api.com/json| python -m json.tool'
  alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
  alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'
  alias gdiff='git diff'
  alias cd="z"
  alias gdiffsplit='DELTA_FEATURES=+side-by-side git diff'

  # Preserve terminfo for kitty when ssh-ing somewhere
  alias ssh='kitten ssh'

  # Temp workaround to disable punycode deprecation logging to stderr
  # https://github.com/bitwarden/clients/issues/6689
  alias bw='NODE_OPTIONS="--no-deprecation" bw'

  # clear both the terminal and tmux history
  clear-scrollback-and-screen () {
    zle clear-screen
    tmux clear-history
  }
  zle -N clear-scrollback-and-screen
  bindkey -e '^L' clear-scrollback-and-screen

  # make CTRL-W to remove the last word in the command line which will allow
  # to delete just last word, for example path components
  # based on https://stackoverflow.com/a/1438523/1208553
  autoload -U select-word-style
  select-word-style bash

  # allow cd without typing cd in interactive shell
  # reference: man zshoptions
  setopt AUTO_CD

} # end of the anonymous function
