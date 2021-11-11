#!/bin/bash
set -e

NAMESPACE_FILE=${1-namespaces}
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

if [[ ! -r $NAMESPACE_FILE ]]; then
  echo "Unable to read file named \"$NAMESPACE_FILE\" for list of namespaces"
  exit 1
fi

NAMESPACE_LIST=$(cat "$NAMESPACE_FILE")
cd cloud-platform-environments
for namespace in $NAMESPACE_LIST; do
  echo "Processing $namespace"
  cd namespaces/live-1.cloud-platform.service.justice.gov.uk/${namespace}
  git checkout main && git pull
  cloud-platform environment migrate
  cd - >/dev/null
  git checkout -b ${USER_INITIALS}-${JIRA_TICKET}-migrate-live-${namespace}
  git add .
  git commit -m "${JIRA_TICKET}: 🔧 Migrate to live context for $namespace" .
  git push --set-upstream origin $(git_current_branch)
  gh pr create --fill
done
