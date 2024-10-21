export EDITOR="nvim"
export VISUAL="nvim"
export GREP_COLORS="mt=01;31" # use red color for grep matches to match rg

if [ -x "$(command -v brew)" ]; then
  # pyenv
  source "$(brew --prefix pyenv)/completions/pyenv.zsh"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"

fi

# needed to allow to work with GPG
# reference: https://gist.github.com/troyfontaine/18c9146295168ee9ca2b30c00bd1b41e
export GPG_TTY=$(tty)

# set colors for unix based tools like ls (also used in fd)
# https://github.com/gibbling/dircolors
alias ls="ls --color --group-directories-first -F"
alias l="ls --color --group-directories-first -Fl"
alias ll="ls --color --group-directories-first --time-style=long-iso -Fl"
alias la="ls --color --group-directories-first --time-style=long-iso -Fla"
alias lah="ls --color --group-directories-first --time-style=long-iso -Flah"
alias grep="grep --color=auto"
alias vi="nvim"
alias vim="nvim"
alias tf='terraform'
alias k='kubectl'
alias rg='rg --ignore-file=${HOME}/.config/fd/ignore'
alias myip='curl -s http://ip-api.com/json| python -m json.tool'
alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'
alias gdiff='git diff'
alias gdiffsplit='DELTA_FEATURES=+side-by-side git diff'
alias ssh='kitten ssh'

# clone the repo and cd to it
gclone() {
  local binary=$(whence -p gclone)
  local dst=$(${binary} ${@})
  [[ -d "${dst}" ]] && cd ${dst}
  pre-commit install --allow-missing-config
}


# Temp workaround to disable punycode deprecation logging to stderr
# https://github.com/bitwarden/clients/issues/6689
alias bw='NODE_OPTIONS="--no-deprecation" bw'

rfcdate() {
  local input=$1
  if [ -z "${input}" ];then
    TZ=UTC date
  else 
    TZ=UTC date --date='@'${input}
  fi
}

unixdate() {
  local input=$1
  if [ -z "${input}" ];then
    date +%s
  else 
    date --date=${input} +%s
  fi
}

local function _must_have_docker() {
  if [ ! -x "$(command -v docker)" ]
  then 
    echo "docker not installed"
    exit 1
  fi
}

cloc() { # count lines of code
  _must_have_docker

	docker run --rm \
    -v ${PWD}:/tmp \
    aldanial/cloc \
    --exclude-dir=.git,vendor $@
}

function ya() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

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

# need to make tab completion predicatable, so it won't complete me any
# random items. I have no idea why is that happening


