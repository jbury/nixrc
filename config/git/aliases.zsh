#!/usr/bin/env zsh

g() { [[ $# = 0 ]] && git status --short . || git $*; }

alias ga='git add'
alias gc='git commit'
alias gca='git commit --amend'
alias gcf='git commit --fixup'
alias gl='git log --graph --pretty="format:%C(yellow)%h%Creset %C(red)%G?%Creset%C(green)%d%Creset %s %Cblue(%cr) %C(bold blue)<%aN>%Creset"'
alias gll='git log --pretty="format:%C(yellow)%h%Creset %C(red)%G?%Creset%C(green)%d%Creset %s %Cblue(%cr) %C(bold blue)<%aN>%Creset"'
alias gpr='git pull --rebase --autostash'
alias gs='git status --short .'
alias gits='git status'

function stata(){
  flag="$1"
  for dir in *; do
    if [ -d "${dir}" ]; then
      cd "${dir}"
      if [ -d .git ]; then
        branch="$(git rev-parse --abbrev-ref HEAD)"
        if [ "${flag}" = "-a" ] || ([ "${branch}" != "main" ] && [ "${branch}" != "master" ]); then
          echo "${dir} -- ${branch}"
        fi
      fi
      cd ..
    fi
  done
}

export GOPRIVATE="gitlab.com/flexe/*"
