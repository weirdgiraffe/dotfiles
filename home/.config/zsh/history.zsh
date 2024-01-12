# https://www.soberkoder.com/better-zsh-history/
# https://jdhao.github.io/2021/03/24/zsh_history_setup/
# https://zsh.sourceforge.io/Doc/Release/Options.html
# https://linux.die.net/man/1/zshoptions
#
# should be set before zim or merged with zim because init
# also modifies hisotry settings, see https://github.com/zimfw/environment

# This option both imports new commands from the history file, and also causes
# your typed commands to be appended to the history file (the latter is like
# specifying INC_APPEND_HISTORY, which should be turned off if this option is
# in effect). The history lines are also output with timestamps ala
# EXTENDED_HISTORY (which makes it easier to find the spot where we left off
# reading the file after it gets re-written).
setopt sharehistory
# incappendhistory and incappendhistorytime should be unset if sharehistory
# is set because they are mutually exclusive
unsetopt incappendhistory
unsetopt incappendhistorytime

# When writing out the history file, older commands that duplicate newer ones
# are omitted.
setopt histsavenodups
# When searching for history entries in the line editor, do not display
# duplicates of a line previously found, even if the duplicates are not
# contiguous.
setopt histfindnodups
# If a new command line being added to the history list duplicates an older
# one, the older command is removed from the list (even if it is not the
# previous event).
setopt histignorealldups
# Remove command lines from the history list when the first character on the
# line is a space, or when one of the expanded aliases contains a leading
# space. Only normal aliases (not global or suffix aliases) have this
# behaviour. Note that the command lingers in the internal history until the
# next command is entered before it vanishes, allowing you to briefly reuse or
# edit the line. If you want to make it vanish right away without entering
# another command, type a space and press return.
setopt histignorespace

# My own custom history behaviour:
#  CTRL-R: search using the shared history, so I can reuse commands from other sessions.
#  UP or CTRL-P: prev command from the local history, so my session history is not messed up.
#  DOWN or CTRL-N: next command from the local history, so my session history is not messed up.
function up-line-or-search-local-history() {
    zle set-local-history 1
    zle history-substring-search-up
    zle set-local-history 0
}
zle -N up-line-or-search-local-history

function down-line-or-search-local-history() {
    zle set-local-history 1
    zle history-substring-search-down
    zle set-local-history 0
}
zle -N down-line-or-search-local-history

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} up-line-or-search-local-history
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} down-line-or-search-local-history
for key ('k') bindkey -M vicmd ${key} up-line-or-search-local-history
for key ('j') bindkey -M vicmd ${key} down-line-or-search-local-history
unset key
