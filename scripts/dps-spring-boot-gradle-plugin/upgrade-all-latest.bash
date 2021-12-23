#!/usr/bin/env bash
set -e

BRANCH_NAME=DT-2783
COMMIT_MESSAGE="DT-2783: ⬆️ Upgrading to Spring Boot 2.5.6 to resolve CVE"
SCRIPTS_BASE_DIR=`pwd`
CODE_BASE_DIR=`cd ../../../ && pwd`

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

for repo in $(cat $SCRIPTS_BASE_DIR/repos-to-upgrade); do
  echo "Switching $repo to main"
  cd $CODE_BASE_DIR/$repo
  git add .
  git stash
  git checkout main && git pull
  cd - >/dev/null
done

echo "About to do the upgrades"

for repo in $(cat $SCRIPTS_BASE_DIR/repos-to-upgrade); do
  echo "Upgrading $repo"
  cd $CODE_BASE_DIR/$repo
  git status -s

  $SCRIPTS_BASE_DIR/upgrade-latest.bash
  git checkout -b "$BRANCH_NAME"
  git commit -m "$COMMIT_MESSAGE" .
  git push --set-upstream origin $(git_current_branch)
  gh pr create --fill >> $SCRIPTS_BASE_DIR/pull_requests_created.txt
  cd - >/dev/null
  echo "Upgraded $repo"
done
