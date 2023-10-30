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
export GREP_COLOR="01;31" # use red color for grep matches to match rg

source ~/.fzf.zsh


export FZF_DEFAULT_OPTS='--color=fg:#575279,bg:#faf4ed,hl:#9893a5,fg+:#9893a5,bg+:#f4ede8,hl+:#286983,info:#907aa9,prompt:#286983,pointer:#286983,marker:#286983,spinner:#56949f,header:#9893a5,gutter:#faf4ed'


# set up global ignore for fd
[ -d ${HOME}/.config/fd/ ] || mkdir -p ${HOME}/.config/fd/
if [ ! -f ${HOME}/.config/fd/ignore ]; then
cat << EOF >| ${HOME}/.config/fd/ignore
.git
.svn
.ropeproject
.terraform
__pycache__
vendor
node_modules
EOF
fi

_fzf_compgen_dir() {
  fd --type d \
    --hidden \
    --follow
}
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow"

_fzf_compgen_path() {
  fd --type f \
    --hidden \
    --follow
}
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow"

export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND


# output current git repository root folder
_git_repo_root() {
	git rev-parse --show-toplevel 2>/dev/null
}

# rr (repo root) cd to the folder relative to the root dir of current repository
rr() {
  local _repo=$(_git_repo_root)
  if [[ -n ${_repo} ]]; then
    cd ${_repo}/$1
  fi
}

# fzf completion for rr command
_fzf_complete_rr() {
  local _repo=$(_git_repo_root)
  [[ -n ${_repo} ]] || return

  local _workdir=$(realpath --relative-to="${_repo}" "$(pwd)")
  local _ls=$(command -v gls)

  _fzf_complete \
    --preview="${_ls:=ls} --color --group-directories-first -F -1 ${_repo:=.}/{}" \
    --prompt="repo:cd> " \
    -- "$@" < <(

      fd --type=d \
      --base-directory=${_repo} \
      --strip-cwd-prefix \
      . | grep -e "${_workdir//./\.}/$" -v
      
    )
}

# fzf completion for vim command
_fzf_complete_vim() {
  local _workdir=$(_git_repo_root)
  _fzf_complete \
    --preview "bat ${_workdir:=.}/{}" \
    --reverse \
    --prompt="vim ❯ " \
    -- "$@" < <(

      fd --type f \
        --hidden \
        --base-directory=${_workdir} \
        --strip-cwd-prefix \
        .

  )
}

__list_users_and_repos() {
  local workdir=${1}
  local function strip_git_suffix() {
    while IFS=$'\n' read -r line; do
      echo "${line%/.git/}"
    done
  }
  # output top level directories
  fd --type=d \
    --exact-depth=1 \
    --base-directory=${workdir}
  # output all folders with .git folder inside
  fd --type=d \
    --no-ignore \
    --hidden \
    --exclude='{vendor,.terraform}' \
    --base-directory=${workdir} \
    '^\.git$'| strip_git_suffix
}

__complete_users_and_repos() {
  local name=$1
  local workdir=$2
  local ls=$(command -v gls)

  _fzf_complete \
    --reverse \
    --preview="${ls:=ls} --color --group-directories-first -F -1 ${workdir:=.}/{}" \
    --prompt="${name}> " \
    -- "$name " < <(
      __list_users_and_repos ${workdir}
		)
}

# cd to some folder inside of go github folder
github() {
  cd ${GOPATH}/src/github.com/$1
}

_fzf_complete_github() {
  __complete_users_and_repos "github" ${GOPATH}/src/github.com
}

gitlab() {
  cd ${GOPATH}/src/gitlab.com/$1
}

_fzf_complete_gitlab() {
  __complete_users_and_repos "gitlab" ${GOPATH}/src/gitlab.com
}

fzf-no-prefix-completion() {
  setopt localoptions noshwordsplit noksh_arrays noposixbuiltins
  local tokens cmd no_trigger
  tokens=(${(z)LBUFFER})
  cmd=${tokens[1]}
  # list of commands which do not require ** prefix for trigger
  no_trigger=(rr github gitlab)
  if [[ -n "${no_trigger[(r)${cmd}]}" ]]; then
    FZF_COMPLETION_TRIGGER="" fzf-completion
  else
    fzf-completion
  fi
}
zle -N fzf-no-prefix-completion

# tab completion of no prefix commands
bindkey '^I' fzf-no-prefix-completion

# CTRL+v will fuzzy open file with vim
bindkey -s "^v" "vim **\t"
