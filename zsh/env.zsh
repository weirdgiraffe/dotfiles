# gcloud settings and completions
export CLOUDSDK_PYTHON=python3.9
if [ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ]; then
  source "${HOME}/google-cloud-sdk/completion.zsh.inc"
fi

# golang specific settings
export GOPATH=${HOME}/go
export GOPRIVATE=github.com/weirdgiraffe,gitlab.com/glassnode

typeset -U path
path+=(
  ${HOME}/bin
  ${GOPATH}/bin
  ${HOME}/.cargo/bin
  ${HOME}/google-cloud-sdk/bin
)
export PATH

export EDITOR="nvim"
export VISUAL="nvim"
export GREP_COLORS="mt=01;31" # use red color for grep matches to match rg


# output current git repository root folder
__git_repo_root() {
	git rev-parse --show-toplevel 2>/dev/null
}

# rr (repo root) cd to the folder relative to the root dir of current repository
rr() {
  local _repo=$(__git_repo_root)
  [[ -d ${_repo} ]] && cd ${_repo}/$1
}

# cd to some folder inside of go github folder
github() {
  cd ${GOPATH}/src/github.com/$1
}

gitlab() {
  cd ${GOPATH}/src/gitlab.com/$1
}

source ${HOME}/.config/fzf/fzf.zsh


# needed to allow to work work with GPG
# reference: https://gist.github.com/troyfontaine/18c9146295168ee9ca2b30c00bd1b41e
export GPG_TTY=$(tty)
