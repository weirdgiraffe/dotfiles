if [[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/fzf/fzf.zsh ]]; then
  source ${XDG_CONFIG_HOME:-$HOME/.config}/fzf/fzf.zsh
fi


export FZF_ALT_C_COMMAND="fd --type d --hidden --follow"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

# this wrapper allows to apply colors dynamically to support automatic
# switch to dark mode, by sourcing the theme file right before the actual
# binary execution.
# NOTE: run in a subshell to not pollute top level shell environment
fzf() {
  (
    source ${XDG_CONFIG_HOME:-$HOME/.config}/fzf/current-theme.zsh
    export FZF_DEFAULT_OPTS='--prompt=": " '${FZF_DEFAULT_OPTS}
    $(whence -p fzf) "$@"
  )
}

_fzf_compgen_dir() { fd --type d --hidden --follow }
_fzf_compgen_path() { fd --type f --hidden --follow }


# output current repository root folder
current_repo() {
  git rev-parse --show-toplevel 2>/dev/null
}

# list all subdirs for the path
subdirs() {
  fd --base-directory="${1}" --type=d --hidden
}

# list all git repos for the path
repos() {
  local base_dir=${1}
  local exclude="{vendor,.terraform}"

  # I just need couple of top level directories to be able
  # to quickly cd to like github.com/weirdgiraffe. And those
  # dirs which I do care about should present in GOPRIVATE
  # env variable already.
  #
  # explantaion of the following line:
  #
  # 1. split GOPRIVATE by comma ${(@s:,:)GOPRIVATE} into an array
  # 2. pick only matching elements ${(M)arr:#pattern}
  # 3. remove prefix ${(@)arr#prefix}
  # 5. join using newline ${(F)arr}
  # 6. remove empty lines sed /^$/d
  #
  # reference: https://zsh.sourceforge.io/Doc/Release/Expansion.html
  echo ${(F@)${(M)${(@s:,:)GOPRIVATE}:#${base_dir:t}*}#${base_dir:t}/} | sed /^$/d

  # output all folders with .git folder inside
  fd --base-directory=${base_dir} --unrestricted --type=d --exclude="${exclude}" --max-depth=4 '^\.git$' | sed 's/\.git\/$//'
}


# rr command to cd within a current repo
rr() {
  local repo=$(current_repo)
  local subdir=${1}
  [[ "${repo}" ]] || return 
  [[ "${query}" ]] || { cd -- "${repo}"; return }
  [[ -d "${repo}/${subdir}" ]] && { cd -- "${repo}/${subdir}"; return }

  subdir=$(subdirs "${repo}" | fzf --smart-case --select-1 --query="${subdir}")
  [[ "${subdir}" ]] && cd -- "${repo}/${subdir}"
}

# fzf completion for rr command
_fzf_complete_rr() {
  local repo=$(current_repo)
  [[ "${repo}" ]] || return 

  _fzf_complete \
    --height=20% \
    --no-scrollbar \
    --no-sort \
    --layout=reverse \
    --info=inline-right \
    --preview="ls --color --group-directories-first -F -1 ${repo:=.}/{}" \
    --preview-window 'right,50%,border-left,+{2}+3/3,~3' \
    -- "${@}" < <( subdirs "${repo}" )
}


# generic switch to the git repository
_switch_to_repository() {
  local base_dir=${1}
  local repo=${2}

  [[ "${base_dir}" ]] || { echo "panic: base_dir is not provided"; return }
  [[ -d "${base_dir}" ]] || { echo "base_dir does not exists: ${base_dir}"; return }

  [[ "${repo}" ]] || { cd -- "${base_dir}"; return }
  [[ -d "${base_dir}/${repo}" ]] && { cd -- "${base_dir}/${repo}"; return }

  repo=$(repos "${base_dir}" | fzf --smart-case --select-1 --query="${repo}")
  [[ "${repo}" ]] && cd -- "${base_dir}/${repo}"
}

# generic fzf completion for _switch_to_repository
_complete_repos() {
  local provider=${1}
  local base_dir=${2}

  [[ "${base_dir}" ]] || { echo "there is no such dir: ${base_dir}"; return }
  [[ -d "${base_dir}" ]] || return

  _fzf_complete \
    --height=20% \
    --no-scrollbar \
    --no-sort \
    --layout=reverse \
    --info=inline-right \
    --preview="ls --color --group-directories-first -F -1 ${workdir:=.}/{}" \
    --preview-window 'right,50%,border-left,+{2}+3/3,~3' \
    -- "${provider} " < <( repos "${base_dir}" )
}

github() { _switch_to_repository "${HOME}/code/github.com" "${1}" }
_fzf_complete_github() { _complete_repos "gitlab" "${HOME}/code/github.com"}

gitlab() { _switch_to_repository "${HOME}/code/gitlab.com" "${1}" }
_fzf_complete_gitlab() { _complete_repos "github" "${HOME}/code/gitlab.com"}


# fzf completion for vim command
_fzf_complete_vim() {
  local curr_dir=$(pwd)
  local base_dir=$(current_repo)
  [[ "${base_dir}" ]] || base_dir="${curr_dir}"

  _fzf_complete \
    --height=20% \
    --layout=reverse \
    --no-scrollbar \
    --info=inline-right \
    -- "$@" < <( fd --base-directory=${base_dir} --type=f --hidden . --exec realpath --relative-to=${curr_dir} {} )
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
