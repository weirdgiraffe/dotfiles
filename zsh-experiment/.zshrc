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

# ------------------------------------------------------------------------------
