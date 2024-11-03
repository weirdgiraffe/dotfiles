source ${XDG_CONFIG_HOME:-$HOME/.config}/fzf/fzf.zsh


export FZF_ALT_C_COMMAND="fd --type d --hidden --follow"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

# this wrapper allows to apply colors dynamically to support automatic
# switch to dark mode, by sourcing the theme file right before the actual
# binary execution.
# NOTE: run in a subshell to not pollute top level shell environment
function fzf() {(
    source ${XDG_CONFIG_HOME:-$HOME/.config}/fzf/current-theme.zsh
    export FZF_DEFAULT_OPTS='--prompt=": " '${FZF_DEFAULT_OPTS}
    $(whence -p fzf) "$@"
)}

_fzf_compgen_dir() {
  fd --type d \
    --hidden \
    --follow
}

_fzf_compgen_path() {
  fd --type f \
    --hidden \
    --follow
}


# output current git repository root folder
__git_repo_root() {
	git rev-parse --show-toplevel 2>/dev/null
}

# rr (repo root) cd to the folder relative to the root dir of current repository
rr() {
  local _repo=$(__git_repo_root)
  [[ -d ${_repo} ]] && cd ${_repo}/$1
}

# fzf completion for rr command
_fzf_complete_rr() {
  local _repo=$(__git_repo_root)
  [[ -n ${_repo} ]] || return
  local _workdir=$(realpath --relative-to="${_repo}" "$(pwd)")

  _fzf_complete \
    --height=20% \
    --no-scrollbar \
    --layout=reverse \
    --info=inline-right \
    --preview="ls --color --group-directories-first -F -1 ${_repo:=.}/{}" \
    --preview-window 'right,50%,border-left,+{2}+3/3,~3' \
    -- "$@" < <(

      fd --type=d \
      --base-directory=${_repo} \
      --strip-cwd-prefix \
      . | grep -e "${_workdir//./\.}/$" -v
      
    )
}

# fzf completion for vim command
_fzf_complete_vim() {
  local _workdir=$(__git_repo_root)
  if [[ -z ${_workdir} ]]; then
    _workdir=$(pwd)
  fi
  local _currdir=$(pwd)

  _fzf_complete \
    --height=20% \
    --layout=reverse \
    --no-scrollbar \
    --info=inline-right \
    -- "$@" < <(
      fd --type=f \
        --hidden \
        --base-directory=${_workdir} \
        . \
        --exec realpath --relative-to=${_currdir} {}
  )
}

local function __list_users_and_repos() {
  local workdir=${1}
  local function strip_git_suffix() {
    while IFS=$'\n' read -r line; do
      echo "${line%/.git/}"
    done
  }

  mkdir -p  ~/.cache/repos/${workdir}
  if [[ ${workdir} -ot ~/.cache/repos/${workdir}/result.txt ]]; then
    cat ~/.cache/repos/${workdir}/result.txt
    return
  fi

  # output top level directories
  fd --type=d \
    --exact-depth=1 \
    --base-directory=${workdir} |\
  tee ~/.cache/repos/${workdir}/result.txt

  # output all folders with .git folder inside
  fd --type=d \
    --no-ignore \
    --hidden \
    --exclude='{vendor,.terraform}' \
    --base-directory=${workdir} \
    '^\.git$'| strip_git_suffix |\
  tee -a ~/.cache/repos/${workdir}/result.txt
}

local function __complete_users_and_repos() {
  local name=$1
  local workdir=$2

  _fzf_complete \
    --height=20% \
    --no-scrollbar \
    --layout=reverse \
    --info=inline-right \
    --preview="ls --color --group-directories-first -F -1 ${workdir:=.}/{}" \
    --preview-window 'right,50%,border-left,+{2}+3/3,~3' \
    -- "$name " < <(
      __list_users_and_repos ${workdir}
    )
}

github() {
  cd ~/code/github.com/$1
}

_fzf_complete_github() {
  __complete_users_and_repos "github" ~/code/github.com
}


gitlab() {
  local gitlab_dir=~/code/gitlab.com
  if [[ -d "${gitlab_dir}" ]]; then
    cd ~/code/src/gitlab.com/$1
  else
    echo "there is no such dir:${gitlab_dir}"
  fi
}

_fzf_complete_gitlab() {
  local gitlab_dir=~/code/gitlab.com
  if [[ -d "${gitlab_dir}" ]]; then
    __complete_users_and_repos "gitlab" ${gitlab_dir}
  fi
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
