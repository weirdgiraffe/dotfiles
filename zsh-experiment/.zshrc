# ------------------------------------------------------------------------------

# set defaults shell keybindings to emacs keybindings
bindkey -e

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

# history setup
# reference: man zshoptions

# where to keep the history file
HISTFILE=${ZDOTDIR}/.zhistory 
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

autoload -Uz zcompile

local function zcompare() {
  if [[ -s ${1} && ( ! -s ${1}.zwc || ${1} -nt ${1}.zwc ) ]]; then
    zcompile ${1}
  fi
}

function zcompare_and_source() {
  zcompare ${1}
  source ${1}
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# completions

# precompile all of the additional completions
if [[ (-s ${ZDOTDIR}/.zcompdump) && ($(brew --prefix)/share/zsh-completions -nt ${ZDOTDIR}/.zcompdump) ]]; then
  setopt EXTENDED_GLOB
  for file in $(brew --prefix)/share/zsh-completions/^(*.zwc)*; do
      zcompare ${file}
  done
  unsetopt EXTENDED_GLOB
fi

fpath=(
  $(brew --prefix)/share/zsh-completions/
  ${HOME}/.local/share/zsh/completions/
  $fpath
)

autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump ]]; then
  compinit -i -d "${ZDOTDIR}/.zcompdump"
else
  compinit -i -C -d "${ZDOTDIR}/.zcompdump"
fi

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
# other plugins

# oh-my-posh: (need to comment out if want to benchmark)
# . <( oh-my-posh init zsh --config=${HOME}/.config/oh-my-posh/config.toml )

# . <(zoxide init zsh)

# precompile and source all my custom functions
for file in ${ZDOTDIR}/functions/*.zsh; do
  zcompare_and_source ${file}
done

zcompare_and_source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# syntax-highlight should be the last plugin
zcompare_and_source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ------------------------------------------------------------------------------
