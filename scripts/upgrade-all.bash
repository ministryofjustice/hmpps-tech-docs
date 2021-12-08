#!/bin/bash
set -e

APPLICATION_FILE=${1-applications}
SCRIPT_FILE=${2-../upgrade-kotlin-mockito.bash}
BRANCH_NAME=${3?No branch specified}
COMMIT_MSG=${4?No commit message specified}

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
. "${DIR}"/common-functions.bash

echo "About to do the upgrades"

while read -r application; do
  cd "$application"
  git_stash_changes_to_main

  $SCRIPT_FILE
  git checkout -b "$BRANCH_NAME"
  git commit -m "$COMMIT_MSG" .
  git push --set-upstream origin "$(git_current_branch)"
  gh pr create --fill

  git_stash_pop_changes
  cd - >/dev/null
done < "$APPLICATION_FILE"
