source ${HOME}/.fzf.zsh

export FZF_DEFAULT_OPTS='--color=fg:#575279,bg:#faf4ed,hl:#9893a5,fg+:#9893a5,bg+:#f4ede8,hl+:#286983,info:#907aa9,prompt:#286983,pointer:#286983,marker:#286983,spinner:#56949f,header:#9893a5,gutter:#faf4ed'

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

export FZF_ALT_C_COMMAND="fd --type d --hidden --follow"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

# fzf completion for rr command
_fzf_complete_rr() {
  local _repo=$(__git_repo_root)
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
  local _workdir=$(__git_repo_root)
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

_fzf_complete_github() {
  __complete_users_and_repos "github" ${GOPATH}/src/github.com
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
