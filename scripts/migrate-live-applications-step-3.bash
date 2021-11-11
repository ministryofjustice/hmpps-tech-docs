#!/bin/bash
set -e

NAMESPACE_FILE=${1-namespaces}
to_context=live-1.cloud-platform.service.justice.gov.uk

if [[ ! -r $NAMESPACE_FILE ]]; then
  echo "Unable to read file named \"$NAMESPACE_FILE\" for list of namespaces"
  exit 1
fi

NAMESPACE_LIST=$(cat "$NAMESPACE_FILE")

for namespace in $NAMESPACE_LIST; do kubectl --context=$to_context -n $namespace get deployments;done | awk '{print $1}' | sort | grep -v NAME
