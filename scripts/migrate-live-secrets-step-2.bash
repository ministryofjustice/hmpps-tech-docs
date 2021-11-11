#!/bin/bash
namespace=${1?No namespace specified}

old=$(kubectl --context=live-1.cloud-platform.service.justice.gov.uk --namespace $namespace get secrets | grep -v -e 'sh.helm.release' -e 'circleci-token-' -e 'default-token-' |awk '{print $1}')
new=$(kubectl --context=live.cloud-platform.service.justice.gov.uk --namespace $namespace get secrets | grep -v -e 'sh.helm.release' -e 'circleci-token-' -e 'default-token-' |awk '{print $1}')

diff <(echo "$old") <(echo "$new")

