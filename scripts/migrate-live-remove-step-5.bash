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
cd cloud-platform-environments/namespaces/live-1.cloud-platform.service.justice.gov.uk
for namespace in $NAMESPACE_LIST; do
  echo "Processing $namespace"
  git checkout main && git pull
  rm -r ${namespace}
  git checkout -b ${USER_INITIALS}-${JIRA_TICKET}-remove-live-1-${namespace}
  git add .
  git commit -m "${JIRA_TICKET}: 🔧 Delete live-1 context for $namespace as now migrated" .
  git push --set-upstream origin $(git_current_branch)
  gh pr create --fill
done
