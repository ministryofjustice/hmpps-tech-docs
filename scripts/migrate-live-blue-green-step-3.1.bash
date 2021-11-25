#!/bin/bash
set -e

APPLICATION_FILE=${1-applications}
ENV_SUFFIX=${2-dev}
USER_INITIALS=${3-pgp}
JIRA_TICKET=${4-DT-2796}

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
[[ $(uname) -eq "Darwin" ]] && NL=$'\\\n' || NL="\n"

for file in $(cat "$APPLICATION_FILE"); do
  cd $file
  sed -Ei '' 's/host: (.*)/host: \1$NL    contextColour: green/' helm_deploy/values-${ENV_SUFFIX}.yaml
  git checkout -b ${USER_INITIALS}-${JIRA_TICKET}-migrate-${ENV_SUFFIX}-to-live
  git commit -m "${JIRA_TICKET}: 🔨 Migrate ${ENV_SUFFIX} to live context" .
  git push --set-upstream origin $(git_current_branch)
  gh pr create --fill
  cd - >/dev/null
done
