#!/bin/bash
set -e

APPLICATION_FILE=${1-applications}
ENV_SUFFIX=${2-dev}
USER_INITIALS=${3-pgp}
JIRA_TICKET=${4-DT-2796}

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "${DIR}"/common-functions.bash

while read -r application;do
  cd "$application"
  git_stash_changes_to_main
  $SED -Ei "s/host: (.*)/host: \1\n    contextColour: green/" "helm_deploy/values-${ENV_SUFFIX}.yaml"
  git checkout -b "${USER_INITIALS}-${JIRA_TICKET}-migrate-${ENV_SUFFIX}-to-live"
  git commit -m "${JIRA_TICKET}: 🔨 Migrate ${ENV_SUFFIX} to live context" .
  git push --set-upstream origin "$(git_current_branch)"
  gh pr create --fill
  git_stash_pop_changes
  cd - >/dev/null
done < "$APPLICATION_FILE"
