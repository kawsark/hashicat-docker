#!/bin/bash

prefix=hashicat
for pod in $(kubectl get pods | grep $prefix | awk '{print $1}')
do
  echo "Displaying certs for Pod: $pod"
  echo "$(kubectl exec -it $pod -c consul-connect-envoy-sidecar -- wget -q -O - localhost:19000/certs)" | jq .
done