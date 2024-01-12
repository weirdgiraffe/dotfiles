# -------------------- zsh keybindings style ------------------
#
bindkey -e # emacs keybindings

# -------------------- zsh-autosuggestions --------------------

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# -------------------- zsh-syntax-highlighting ----------------

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=10'

# -------------------- zim initialisation ---------------------

# https://github.com/zimfw/zimfw?tab=readme-ov-file#manual-installation
zstyle ':zim:zmodule' use 'degit'

ZIM_HOME=${HOME}/.local/state/zim
[[ -d ${ZIM_HOME} ]] || mkdir -p ${ZIM_HOME}

# download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

# initialize zim modules.
source ${ZIM_HOME}/init.zsh

