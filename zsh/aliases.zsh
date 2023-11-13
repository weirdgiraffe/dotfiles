alias vi="nvim"
alias vim="nvim"
alias tf='terraform'
alias k='kubectl'
alias dc="docker compose"

alias myip='curl -s http://ip-api.com/json| python -m json.tool'
alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'

rfcdate() {
  local gdate=$(command -v gdate)
  local input=$1
  if [ -z "${input}" ];then
    TZ=UTC ${gdate:=date}
  else 
    TZ=UTC ${gdate:=date} --date='@'${input}
  fi
}

unixdate() {
  local gdate=$(command -v gdate)
  local input=$1
  if [ -z "${input}" ];then
    ${gdate:=date} +%s
  else 
    ${gdate:=date} --date=${input} +%s
  fi
}

local function _must_have_docker() {
	if [ ! -x "$(command -v docker)" ] then 
    echo "docker not installed"
    exit 1
  fi
}

function cloc() { # count lines of code
  _must_have_docker

	docker run --rm \
    -v ${PWD}:/tmp \
    aldanial/cloc \
    --exclude-dir=.git,vendor $@
}


alias rg='rg --ignore-file=${HOME}/.config/rg/ignore'

# jupiter will run a docker container with a jupiter inside, 
# so you can run your notebook
function jupyter() {
  _must_have_docker

  local filename=${1}
  [ -f ${filename} ] || cat << EOF >| ${filename}
{
 "cells": [],
 "metadata": {},
 "nbformat": 4,
 "nbformat_minor": 5
}
EOF

  local notebooks=/tmp/jupyter/notebooks
  mkdir -p ${notebooks}
  local container=jupyter-${filename}

  if [ -z "$(docker ps -q --filter name=${container})" ]; then
    set -x
    docker run --rm -d \
      --name=${container} \
      -v $(realpath ${filename}):/home/jovyan/${filename} \
      -p 8888:8888 \
      jupyter/minimal-notebook:lab-4.0.7 \
      start-notebook.sh --NotebookApp.token=''
    set +x
  fi
}
