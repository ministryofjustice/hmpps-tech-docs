#!/bin/bash
set -e

NAMESPACE_FILE=${1-namespaces}

if [[ ! -r $NAMESPACE_FILE ]]; then
  echo "Unable to read file named \"$NAMESPACE_FILE\" for list of namespaces"
  exit 1
fi

NAMESPACE_LIST=$(cat "$NAMESPACE_FILE")

for namespace in $NAMESPACE_LIST; do kubectl -n $namespace get deployments;done | awk '{print $1}' | sort | grep -v NAME
