#!/bin/bash
set -e
from_context=live-1.cloud-platform.service.justice.gov.uk
namespace=${1?No namespace specified}
to_context=live.cloud-platform.service.justice.gov.uk
SECRETS_FILE=${2-secrets}

while read -r secret; do
  echo "Processing $secret"

  kubectl --context "$from_context" -n "$namespace" get secret "$secret" -ojson | \
    jq -r '. | {apiVersion, kind, metadata, data, type} | del(.metadata.annotations."kubectl.kubernetes.io/last-applied-configuration", .metadata.namespace, .metadata.creationTimestamp, .metadata.resourceVersion, .metadata.selfLink, .metadata.uid)' | \
    kubectl --context "$to_context" -n "$namespace" create -f -

  kubectl --context "$to_context" -n "$namespace" get secret "$secret"
done < "$SECRETS_FILE"
