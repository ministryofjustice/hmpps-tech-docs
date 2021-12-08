#!/bin/bash

NAMESPACE_FILE=${1-namespaces}
to_context=live-1.cloud-platform.service.justice.gov.uk

if [[ ! -r $NAMESPACE_FILE ]]; then
  echo "Unable to read file named \"$NAMESPACE_FILE\" for list of namespaces"
  exit 1
fi
NAMESPACE_LIST=$(cat "$NAMESPACE_FILE")

cd "cloud-platform-environments/namespaces/$to_context" || exit 1

echo "$NAMESPACE_LIST" | while read -r namespace; do
  echo "$namespace" && grep -r "$namespace" --exclude-dir="$namespace"
done

