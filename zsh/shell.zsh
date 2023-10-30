# prevent terminal suspend on CTRL+S
[ -t 0 ] && stty -ixon
[ -z "$LANG" ] && export LANG='en_US.UTF-8'

# ensure terminal is 256 colors
if [ "$TERM" = "tmux" -o "$TERM" = "tmux-256color" ]; then
	export TERM=tmux-256color
fi
if [ "$TERM" = "xterm" -o "$TERM" = "xterm-256color" ]; then
	export TERM=xterm-256color
fi
if [ "$TERM" = "screen" -o "$TERM" = "screen-256color" ]; then
	export TERM=screen-256color
fi

# configure shell history
setopt hist_save_no_dups          # deduplicate history entries
setopt hist_ignore_space          # do not save lines starting with space in history
unsetopt inc_append_history       # do share history between terminals
unsetopt inc_append_history_time  #
setopt share_history              # share history between different terminal sessions
bindkey -e                        # set emacs keybinding for zsh
bindkey "^[[3~"  delete-char      # make Del key work instead of outputing ~
bindkey "^[3;5~" delete-char      #

# ↑ and CTRL+P will access a local history only
# but CTRL+R will work with a global history
function up-line-or-search-local-history() {
zle set-local-history 1
zle up-line-or-history
zle set-local-history 0
}
zle -N up-line-or-search-local-history
bindkey '^P' up-line-or-search-local-history
bindkey '^[[A' up-line-or-search-local-history

# ↓ and CTRL+N will access a local history only
# but CTRL+R will work with a global history
function down-line-or-search-local-history() {
zle set-local-history 1
zle down-line-or-history
zle set-local-history 0
}
zle -N down-line-or-search-local-history
bindkey '^N' down-line-or-search-local-history
bindkey '^[[B' down-line-or-search-local-history
