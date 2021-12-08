#!/bin/bash
set -e

NAMESPACE_FILE=${1-namespaces}
USER_INITIALS=${2-pgp}
JIRA_TICKET=${3-DT-2796}

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "${DIR}"/common-functions.bash

if [[ ! -r $NAMESPACE_FILE ]]; then
  echo "Unable to read file named \"$NAMESPACE_FILE\" for list of namespaces"
  exit 1
fi

NAMESPACE_LIST=$(cat "$NAMESPACE_FILE")
cd cloud-platform-environments/namespaces/live-1.cloud-platform.service.justice.gov.uk
git_stash_changes_to_main
echo "$NAMESPACE_LIST" | while read -r namespace; do
  echo "Processing $namespace"
  git checkout main
  rm -r "${namespace}"
  git checkout -b "${USER_INITIALS}-${JIRA_TICKET}-remove-live-1-${namespace}"
  git add .
  git commit -m "${JIRA_TICKET}: 🔧 Delete live-1 context for $namespace as now migrated" .
  git push --set-upstream origin "$(git_current_branch)"
  gh pr create --fill
done
git_stash_pop_changes
