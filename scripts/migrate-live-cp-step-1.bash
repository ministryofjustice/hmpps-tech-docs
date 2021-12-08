#!/bin/bash
set -e

NAMESPACE_FILE=${1-namespaces}
USER_INITIALS=${3-pgp}
JIRA_TICKET=${4-DT-2796}

if [[ ! -r $NAMESPACE_FILE ]]; then
  echo "Unable to read file named \"$NAMESPACE_FILE\" for list of namespaces"
  exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "${DIR}"/common-functions.bash

NAMESPACE_LIST=$(cat "$NAMESPACE_FILE")

cd cloud-platform-environments
git_stash_changes_to_main
echo "$NAMESPACE_LIST" | while read -r namespace; do
  echo "Processing $namespace"
  cd "namespaces/live-1.cloud-platform.service.justice.gov.uk/${namespace}"
  cloud-platform environment migrate
  cd - >/dev/null
  git checkout main
  git checkout -b "${USER_INITIALS}-${JIRA_TICKET}-migrate-live-${namespace}"
  git add .
  git commit -m "${JIRA_TICKET}: 🔧 Migrate to live context for $namespace" .
  git push --set-upstream origin "$(git_current_branch)"
  gh pr create --fill
done
git_stash_pop_changes
