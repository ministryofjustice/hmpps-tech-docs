#!/bin/bash
set -e

APPLICATION_FILE=${1-applications}
SCRIPT_FILE=${2-../upgrade-kotlin-mockito.bash}
BRANCH_NAME=${3?No branch specified}
COMMIT_MSG=${4?No commit message specified}

function git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

function gsm() {
  CHANGES=$(git status -s | grep -v '??' | wc -l)
  [[ $CHANGES -eq 0 ]] || git stash
  git checkout main || git checkout master
  git pull
  [[ $CHANGES -eq 0 ]] || git stash pop
}

echo "About to do the upgrades" 

for file in $(cat $APPLICATION_FILE); do
  cd $file

  gsm #switch to main

  $SCRIPT_FILE
  git checkout -b "$BRANCH_NAME"
  git commit -m "$COMMIT_MSG" .
  git push --set-upstream origin $(git_current_branch)
  gh pr create --fill
  cd - >/dev/null
done
